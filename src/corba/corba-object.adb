--  The following subprograms still have to be implemented :
--     Get_Policy
--     Is_A
--     Non_Existent

with Ada.Tags;

with GNAT.HTable;

with PolyORB.Log;
pragma Elaborate_All (PolyORB.Log);

with PolyORB.Smart_Pointers;

with CORBA.AbstractBase;
with CORBA.ORB;

package body CORBA.Object is

   use PolyORB.Log;
   use PolyORB.Smart_Pointers;

   package L is new PolyORB.Log.Facility_Log ("corba.object");
   procedure O (Message : in Standard.String; Level : Log_Level := Debug)
     renames L.Output;

   type Internal_Object is new PolyORB.Smart_Pointers.Entity with record
      The_Object : PolyORB.Objects.Object_Id_Access;
   end record;
   type Internal_Object_Access is access all Internal_Object;

   ----------
   -- Hash --
   ----------

   function Hash
     (Self    : Ref;
      Maximum : CORBA.Unsigned_Long)
      return CORBA.Unsigned_Long
   is
      type My_Range is new Long range 0 .. Long (Maximum);
      function My_Hash is new GNAT.HTable.Hash (My_Range);
   begin
      return CORBA.Unsigned_Long
        (My_Hash (To_Standard_String (CORBA.ORB.Object_To_String (Self))));
   end Hash;

   ----------
   -- Is_A --
   ----------

   function Is_A
     (Self            : in Ref;
      Logical_Type_Id : in Standard.String)
     return CORBA.Boolean
   is
   begin
      raise PolyORB.Not_Implemented;
      return Is_A (Self, Logical_Type_Id);
   end Is_A;

   -------------------
   -- Is_Equivalent --
   -------------------

   function Is_Equivalent
     (Self         : Ref;
      Other_Object : Ref'Class)
     return Boolean
   is
      use PolyORB.Smart_Pointers;
   begin
      return (Entity_Of (Self) = Entity_Of (Other_Object));
   end Is_Equivalent;

   ------------
   -- Is_Nil --
   ------------

   function Is_Nil (Self : in Ref) return CORBA.Boolean is
   begin
      return Is_Nil (PolyORB.Smart_Pointers.Ref (Self));
   end Is_Nil;

   ------------------
   -- Non_Existent --
   ------------------

   function Non_Existent (Self : Ref) return CORBA.Boolean is
   begin
      raise PolyORB.Not_Implemented;
      return Non_Existent (Self);
   end Non_Existent;

   --------------------
   -- Create_Request --
   --------------------

   procedure Create_Request
     (Self      : in     Ref;
      Ctx       : in     CORBA.Context.Ref;
      Operation : in     Identifier;
      Arg_List  : in     CORBA.NVList.Ref;
      Result    : in out NamedValue;
      Request   :    out CORBA.Request.Object;
      Req_Flags : in     Flags) is
   begin
      CORBA.Request.Create_Request
        (CORBA.AbstractBase.Ref (Self),
         Ctx,
         Operation,
         Arg_List,
         Result,
         Request,
         Req_Flags);
   end Create_Request;

   --------------------
   -- Create_Request --
   --------------------

   procedure Create_Request
     (Self      : in     Ref;
      Ctx       : in     CORBA.Context.Ref;
      Operation : in     Identifier;
      Arg_List  : in     CORBA.NVList.Ref;
      Result    : in out NamedValue;
      Exc_List  : in     ExceptionList.Ref;
      Ctxt_List : in     ContextList.Ref;
      Request   :    out CORBA.Request.Object;
      Req_Flags : in     Flags) is
   begin
      CORBA.Request.Create_Request
        (CORBA.AbstractBase.Ref (Self),
         Ctx,
         Operation,
         Arg_List,
         Result,
         Exc_List,
         Ctxt_List,
         Request,
         Req_Flags);
   end Create_Request;

   -------------
   -- Release --
   -------------

   procedure Release (Self : in out Ref) is
   begin
      Release (PolyORB.Smart_Pointers.Ref (Self));
   end Release;

   function  Object_To_String
     (Obj : in CORBA.Object.Ref'Class)
     return CORBA.String is
   begin
      return CORBA.ORB.Object_To_String (Obj);
   end Object_To_String;

--    --------------------------
--    -- Set_Policy_Overrides --
--    --------------------------

--    procedure Set_Policy_Overrides
--      (Self     : in Ref;
--       Policies :    CORBA.Policy.PolicyList;
--       Set_Add  :    SetOverrideType)
--    is
--    begin
--       null;
--    end Set_Policy_Overrides;

   --  XXX remove
--    ---------------------
--    -- To_CORBA_Object --
--    ---------------------

--    function To_CORBA_Object
--      (O : in PolyORB.Objects.Object_Id)
--      return Ref
--    is
--       Result : Ref;
--       Internal : Internal_Object_Access;
--    begin
--       Internal := new Internal_Object;
--       Internal.The_Object := new PolyORB.Objects.Object_Id'(O);

--       PolyORB.Smart_Pointers.Set
--         (PolyORB.Smart_Pointers.Ref (Result),
--          Entity_Ptr (Internal));
--       return Result;
--    end To_CORBA_Object;

   ----------------------
   -- To_PolyORB_Object --
   ----------------------

   function To_PolyORB_Object
     (R : in Ref)
     return PolyORB.Objects.Object_Id
   is
   begin
      return Internal_Object_Access (Entity_Of (R)).The_Object.all;
   end To_PolyORB_Object;

   function To_PolyORB_Ref
     (R : in Ref)
     return PolyORB.References.Ref
   is
      E : constant PolyORB.Smart_Pointers.Entity_Ptr
        := Entity_Of (R);
   begin
      if E = null then
         raise Constraint_Error;
      end if;
      pragma Debug
        (O ("Converting entity of type "
            & Ada.Tags.External_Tag (E.all'Tag)
            & " into PolyORB ref"));
      if E.all in Reference_Info then
         return Reference_Info (E.all).IOR.Ref;
      else
         --  Must "export" (in the Jonathan sense)
         --  this interface to make it remotely
         --  callable, i.e. must construct or retrieve
         --  a PolyORB.References.Reference for this entity.
         raise PolyORB.Not_Implemented;
      end if;
   end To_PolyORB_Ref;

   function TC_Object return CORBA.TypeCode.Object
     renames CORBA.TypeCode.TC_Object;

end CORBA.Object;
