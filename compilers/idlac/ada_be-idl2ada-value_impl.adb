------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--            A D A _ B E . I D L 2 A D A . V A L U E _ I M P L             --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2001-2013, Free Software Foundation, Inc.          --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.                                               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
--                  PolyORB is maintained by AdaCore                        --
--                     (email: sales@adacore.com)                           --
--                                                                          --
------------------------------------------------------------------------------

with Idl_Fe.Tree;           use Idl_Fe.Tree;
with Idl_Fe.Tree.Synthetic;           use Idl_Fe.Tree.Synthetic;

with Ada_Be.Identifiers;    use Ada_Be.Identifiers;
with Ada_Be.Debug;
pragma Elaborate_All (Ada_Be.Debug);

with Ada_Be.Idl2Ada.Impl;
with Ada_Be.Idl2Ada.Skel;

package body Ada_Be.Idl2Ada.Value_Impl is

   Flag : constant Natural := Ada_Be.Debug.Is_Active
     ("ada_be.idl2ada.value_impl");
   procedure O is new Ada_Be.Debug.Output (Flag);

   ----------------------------------------------
   -- End of internal subprograms declarations --
   ----------------------------------------------

   ---------------------
   --  Gen_Scope_Spec --
   ---------------------
   procedure Gen_Node_Spec
     (CU   : in out Compilation_Unit;
      Node : Node_Id) is
   begin
      case Kind (Node) is
         when K_ValueType =>

            NL (CU);
            Put (CU, "type Object is new ");

            --  check parent
            declare
               Primary_Parent : constant Node_Id
                 := Idl_Fe.Tree.Synthetic.Primary_Parent (Node);
            begin
               if Primary_Parent = No_Node then
                  Add_With (CU, "CORBA.Value");
                  Put (CU, "CORBA.Value.Impl_Base");
               else
                  Add_With (CU,
                            Ada_Full_Name (Primary_Parent)
                            & ".Value_Impl");
                  Put (CU, Ada_Full_Name (Primary_Parent)
                       & ".Value_Impl.Object");
               end if;
            end;

            --  write members
            declare
               First : Boolean := True;
               It   : Node_Iterator;
               Member_Node : Node_Id;
            begin
               Init (It, Contents (Node));
               while not Is_End (It) loop
                  Get_Next_Node (It, Member_Node);
                  if Kind (Member_Node) = K_State_Member then
                     declare
                        Decl_Iterator : Node_Iterator;
                        Decl_Node : Node_Id;
                     begin
                        if First then
                           PL (CU, " with record");
                           II (CU);
                           First := False;
                        end if;
                        Init (Decl_Iterator,
                              State_Declarators (Member_Node));
                        while not Is_End (Decl_Iterator) loop
                           Get_Next_Node (Decl_Iterator, Decl_Node);
                           if Kind (Decl_Node) = K_Declarator then
                              Gen_Node_Stubs_Spec (CU, Decl_Node);
                              Put (CU, " : ");
                              Gen_Node_Stubs_Spec
                                (CU, State_Type (Member_Node));
                              PL (CU, ";");
                           end if;
                        end loop;
                     end;
                  end if;
               end loop;
               if First then
                  PL (CU, " with null record;");
               else
                  DI (CU);
                  PL (CU, "end record;");
               end if;
               NL (CU);
            end;

            PL (CU, "type Object_Ptr is access all Object'Class;");

         when K_Initializer =>
            Gen_Initializer_Profile (CU,
                                     "Object_Ptr",
                                     Node);
            PL (CU, ";");

         when K_Operation =>
            Ada_Be.Idl2Ada.Impl.Gen_Node_Spec (CU, Node);

         when K_State_Member =>
            null;

         when others =>
            null;
      end case;
   end Gen_Node_Spec;

   ---------------------
   --  Gen_Scope_Body --
   ---------------------
   procedure Gen_Node_Body
     (CU   : in out Compilation_Unit;
      Node : Node_Id) is
   begin
      case Kind (Node) is

         when K_ValueType =>
            if Supports (Node) /= Nil_List then
               Add_With
                 (CU, Ada_Full_Name (Node)
                  & Ada_Be.Idl2Ada.Skel.Suffix (Is_Delegate => False));

            end if;

         when K_Operation =>
            --  for public state members, the operation body is
            --  fully generated.
            if Original_Node (Node) = No_Node
              or else Kind (Original_Node (Node)) /= K_State_Member
            then
               Ada_Be.Idl2Ada.Impl.Gen_Node_Body (CU, Node);
            else
               pragma Debug (O ("Generating .value_impl for state member"));
               declare
                  Is_Get : constant Boolean
                    := Kind (Operation_Type (Node)) /= K_Void;
               begin
                  NL (CU);
                  Gen_Operation_Profile (CU, Node, "access Object");
                  PL (CU, " is");
                  PL (CU, "begin");
                  II (CU);
                  if Is_Get then
                     Put (CU,
                          "return Self.all.");
                     Put (CU,
                          Ada_Name (Head (State_Declarators
                                          (Original_Node (Node)))));
                     PL (CU, ";");
                  else
                     Put (CU,
                          "Self.all.");
                     Put (CU,
                          Ada_Name (Head (State_Declarators
                                          (Original_Node (Node)))));
                     PL (CU, " := To;");
                  end if;
                  DI (CU);
                  PL (CU, "end " & Ada_Operation_Name (Node) & ";");
               end;
            end if;

         when K_Initializer =>
            Gen_Initializer_Profile (CU,
                                     "Object_Ptr",
                                     Node);
            PL (CU, " is");
            II (CU);
            PL (CU, "Result : Object_Ptr := new Object;");
            DI (CU);
            PL (CU, "begin");
            II (CU);
            NL (CU);
            PL (CU, "--  Insert implementation of " & Ada_Name (Node));
            NL (CU);
            PL (CU, "return Result;");
            DI (CU);
            PL (CU, "end " & Ada_Name (Node) & ";");

         when others =>
            null;

      end case;
   end Gen_Node_Body;

end Ada_Be.Idl2Ada.Value_Impl;
