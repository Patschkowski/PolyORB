------------------------------------------------------------------------------
--                                                                          --
--                          PolyORB COMPONENTS                               --
--                                                                          --
--                        G I O P. G I O P 1.0                              --
--                                                                          --
--                               B o d y                                    --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Streams; use Ada.Streams;
with Ada.Strings;
with Ada.Strings.Unbounded;

with CORBA;

with PolyORB.Buffers;             use PolyORB.Buffers;
with PolyORB.Binding_Data;        use PolyORB.Binding_Data;
with PolyORB.Binding_Data.IIOP;
with PolyORB.Log;
pragma Elaborate_All (PolyORB.Log);
with PolyORB.Protocols;           use PolyORB.Protocols;
with PolyORB.References;          use PolyORB.References;
with PolyORB.Representations.CDR; use PolyORB.Representations.CDR;
with PolyORB.Types;

package body PolyORB.Protocols.GIOP.GIOP_1_0 is

   use PolyORB.Log;
   use PolyORB.Objects;
   use PolyORB.Types;

   package L is new PolyORB.Log.Facility_Log ("polyorb.protocols.giop.giop_1_0");
   procedure O (Message : in String; Level : Log_Level := Debug)
     renames L.Output;

   Nobody_Principal : constant Ada.Strings.Unbounded.Unbounded_String
     := Ada.Strings.Unbounded.To_Unbounded_String ("nobody");

   ------------------
   -- To_Principal --
   -------------------

--   function To_Principal
--     (S : String)
--     return Principal
--   is
--      Octets : Stream_Element_Array (1 .. S'Length + 1);
--   begin
--      for I in Octets'First .. Octets'Last - 1 loop
--         Octets (I) := Types.Octet (Character'Pos (S (S'First + I - 1)));
--      end loop;
--      Octets (Octets'Last) := 0;
--      return Octets;
--   end To_Principal;

   --------------------------
   -- Marshall_GIOP_Header --
   --------------------------

   procedure Marshall_GIOP_Header
     (Buffer       : access Buffer_Type;
      Message_Type : in Msg_Type;
      Message_Size : in Stream_Element_Offset)
   is
      use Representations.CDR;
   begin

      if Message_Type = Fragment then
         raise GIOP_Error;
      end if;

      --  Magic
      for I in Magic'Range loop
         Marshall (Buffer, Types.Octet (Magic (I)));
      end loop;

      --  Version
      Marshall (Buffer, Major_Version);
      Marshall (Buffer, Minor_Version);

      --  Endianness
      Marshall (Buffer, Types.Boolean
                (Endianness (Buffer.all) = Little_Endian));

      --  Message type
      Marshall (Buffer, Message_Type);

      --  Message size
      Marshall
        (Buffer,
         Types.Unsigned_Long (Message_Size - Message_Header_Size));

   end Marshall_GIOP_Header;

   ------------------------------
   -- Marshall_Request_Message --
   ------------------------------

   procedure Marshall_Request_Message
     (Buffer            : access Buffer_Type;
      Request_Id        : in Types.Unsigned_Long;
      Target_Profile    : in Binding_Data.Profile_Access;
      Response_Expected : in Boolean;
      Operation         : in Requests.Operation_Id)
   is
      use Representations.CDR;

   begin

      --  Service context
      Marshall (Buffer, Types.Unsigned_Long (No_Context));

      --  Request id
      Marshall (Buffer, Request_Id);

      --  Response expected
      Marshall (Buffer, Response_Expected);

      --  Object key
      Marshall (Buffer, Stream_Element_Array
                (Binding_Data.IIOP.Get_Object_Key
                (IIOP.IIOP_Profile_Type (Target_Profile.all))));

      --  Operation
      Marshall (Buffer, Operation);

      --  Principal
      Marshall (Buffer, Types.String (Nobody_Principal));

   end Marshall_Request_Message;

   ---------------------------
   -- No_Exception_Marshall --
   ---------------------------

   procedure Marshall_No_Exception
     (Buffer      : access Buffer_Type;
      Request_Id  : in Types.Unsigned_Long) is
   begin


      --  Service context
      Marshall (Buffer, Types.Unsigned_Long (No_Context));

      --  Request id
      Marshall (Buffer, Request_Id);

      --  Reply Status
      Marshall (Buffer, GIOP.No_Exception);

   end Marshall_No_Exception;

   -------------------------------------
   --  System Exception Marshall
   -------------------------------------

   procedure Marshall_Exception
     (Buffer           : access Buffer_Type;
      Request_Id       : in Types.Unsigned_Long;
      Exception_Type   : in Reply_Status_Type;
      Occurence        : in CORBA.Exception_Occurrence) is
   begin

      pragma Assert (Exception_Type in User_Exception  .. System_Exception);

      --  Service context
      Marshall (Buffer, Types.Unsigned_Long (No_Context));

      --  Request id
      Marshall (Buffer, Request_Id);

      --  Reply Status
      Marshall (Buffer, Exception_Type);

      --  Occurrence
      Marshall (Buffer, Occurence);

   end  Marshall_Exception;

   -------------------------------
   -- Location_Forward_Marshall --
   -------------------------------

   procedure Marshall_Location_Forward
     (Buffer           : access Buffer_Type;
      Request_Id       : in  Types.Unsigned_Long;
      Forward_Ref      : in  PolyORB.References.IOR.IOR_Type)
   is
      use References.IOR;
   begin

      --  Service context
      Marshall (Buffer, Types.Unsigned_Long (No_Context));

      --  Request id
      Marshall (Buffer, Request_Id);

      --  Reply Status
      Marshall (Buffer, GIOP.Location_Forward);

      --  Object reference
      References.IOR.Marshall (Buffer, Forward_Ref);

   end  Marshall_Location_Forward;

   --------------------------------
   -- Request Message Unmarshall --
   --------------------------------

   procedure Unmarshall_Request_Message
     (Buffer            : access Buffer_Type;
      Request_Id        : out Types.Unsigned_Long;
      Response_Expected : out Boolean;
      Object_Key        : out Objects.Object_Id_Access;
      Operation         : out Types.String)
   is
      Service_Context : Types.Unsigned_Long := Unmarshall (Buffer);
      Principal       : Types.String;
   begin
      --  Service context
      if Service_Context /= No_Context then
         pragma Debug (O ("Request_Message : incorrect context"
                          & Service_Context'Img));
         raise GIOP_Error;
      end if;

      --  Request id
      Request_Id := Unmarshall (Buffer);

      --  Response expected
      Response_Expected := Unmarshall (Buffer);

      --  Object Key
      declare
         Obj : Stream_Element_Array := Unmarshall (Buffer);
      begin
         Object_Key := new Object_Id'(Object_Id (Obj));
      end;
      --  Operation
      Operation :=  Unmarshall (Buffer);

      --  Principal
      Principal :=  Unmarshall (Buffer);
   end Unmarshall_Request_Message;

   ---------------------------------------
   --- Reply Message Unmarshall ----------
   --------------------------------------


   procedure Unmarshall_Reply_Message
     (Buffer       : access Buffer_Type;
      Request_Id   : out Types.Unsigned_Long;
      Reply_Status : out Reply_Status_Type)
   is
      Service_Context : Types.Unsigned_Long := Unmarshall (Buffer);
   begin

      --  Service context
      if Service_Context /= No_Context then
         pragma Debug
           (O ("Reply_Message : incorrect context" & Service_Context'Img));
         raise GIOP_Error;
      end if;

      --  Request id
      Request_Id := Unmarshall (Buffer);

      --  Reply Status
      Reply_Status := Unmarshall (Buffer);

   end Unmarshall_Reply_Message;

end PolyORB.Protocols.GIOP.GIOP_1_0;
