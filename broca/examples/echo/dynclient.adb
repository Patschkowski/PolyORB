------------------------------------------------------------------------------
--                                                                          --
--                          ADABROKER COMPONENTS                            --
--                                                                          --
--                           D Y N C L I E N T                              --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $LastChangedRevision$
--                                                                          --
--            Copyright (C) 1999 ENST Paris University, France.             --
--                                                                          --
-- AdaBroker is free software; you  can  redistribute  it and/or modify it  --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. AdaBroker  is distributed  in the hope that it will be  useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with AdaBroker; see file COPYING. If  --
-- not, write to the Free Software Foundation, 59 Temple Place - Suite 330, --
-- Boston, MA 02111-1307, USA.                                              --
--                                                                          --
--             AdaBroker is maintained by ENST Paris University.            --
--                     (email: broker@inf.enst.fr)                          --
--                                                                          --
------------------------------------------------------------------------------

--   echo dynamic client.
with Ada.Command_Line;
with Text_IO; use Text_IO;
with CORBA; use CORBA;
with CORBA.Object;
with CORBA.Context;
with CORBA.Request;
with CORBA.NVList;
with CORBA.ORB;

procedure DynClient is
   Sent_Msg : CORBA.String := To_CORBA_String ("Hello Dynamic World");
   Operation_Name : CORBA.Identifier := To_CORBA_String ("echoString");
   Arg_Name : CORBA.Identifier := To_CORBA_String ("Mesg");
   IOR : CORBA.String;
   myecho : CORBA.Object.Ref;
   Request : CORBA.Request.Object;
   Ctx : CORBA.Context.Ref;
   Arg : CORBA.Any;
   Arg_List : CORBA.NVList.Ref;
   Result : CORBA.NamedValue;
   Result_Name : CORBA.String := To_CORBA_String ("Result");
   Result_Value : CORBA.String := To_CORBA_String ("Not Successfull");
   Recv_Msg : CORBA.String;
begin

   if Ada.Command_Line.Argument_Count < 1 then
      Put_Line ("usage : client <IOR_string_from_server>");
      return;
   end if;

   --  transforms the Ada string into CORBA.String
   IOR := CORBA.To_CORBA_String (Ada.Command_Line.Argument (1));

   --  getting the CORBA.Object
   CORBA.ORB.String_To_Object (IOR, myecho);

   --  creating the argument list
   Arg := CORBA.To_Any (Sent_Msg);
   CORBA.NVList.Add_Item (Arg_List,
                          Arg_Name,
                          Arg,
                          CORBA.ARG_IN);

   --  setting the result type
   Result := (Name => Identifier (Result_Name),
              Argument => To_Any (Result_Value),
              Arg_Modes => 0);

   --  creating a request
   CORBA.Object.Create_Request (myecho,
                                Ctx,
                                Operation_Name,
                                Arg_List,
                                Result,
                                Request,
                                0);

   --  sending message
   CORBA.Request.Invoke (Request, 0);

   --  getting the answer
   Recv_Msg := From_Any (CORBA.Request.Return_Value (Request).Argument);

   --  printing result
   Put_Line ("I said : " & CORBA.To_Standard_String (Sent_Msg));
   Put_Line ("The object answered : " & CORBA.To_Standard_String (Recv_Msg));

end DynClient;
