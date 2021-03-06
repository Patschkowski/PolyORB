------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                      A D A _ B E . M A P P I N G S                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2001-2012, Free Software Foundation, Inc.          --
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

--  The abstract interface for all personality mappings of distributed
--  object service descriptions (i.e. IDL trees).

with Ada.Strings.Unbounded;
with Idl_Fe.Types;

package Ada_Be.Mappings is

   package ASU renames Ada.Strings.Unbounded;

   function "+" (S : String)
     return ASU.Unbounded_String
     renames ASU.To_Unbounded_String;

   function "-" (US : ASU.Unbounded_String)
     return String
     renames ASU.To_String;

   type Mapping_Type is abstract tagged private;
   --  The root type for all personality mappings. Each
   --  mapping must provide a concrete derivation of Mapping_Type
   --  that implements the following operations.

   function Library_Unit_Name
     (Self : access Mapping_Type;
      Node : Idl_Fe.Types.Node_Id)
     return String
      is abstract;
   --  Return the name of the library unit that contains the
   --  entity mapping Node.

   function Client_Stubs_Unit_Name
     (Self : access Mapping_Type;
      Node : Idl_Fe.Types.Node_Id)
     return String
      is abstract;
   --  Return the name of the library unit that contains the
   --  client stubs for interface or valuetype Node.

   function Server_Skel_Unit_Name
     (Self : access Mapping_Type;
      Node : Idl_Fe.Types.Node_Id)
     return String
      is abstract;
   --  Return the name of the library unit that contains the
   --  server skeleton for interface or valuetype Node.

   function Self_For_Operation
     (Self : access Mapping_Type;
      Node : Idl_Fe.Types.Node_Id)
     return String
      is abstract;
   --  Return an expression that resolves to denote the target
   --  object reference in a calling stub unit.

   procedure Map_Type_Name
     (Self : access Mapping_Type;
      Node : Idl_Fe.Types.Node_Id;
      Unit : out ASU.Unbounded_String;
      Typ  : out ASU.Unbounded_String)
      is abstract;
   --  Given a Node that denotes a type, provide a library
   --  unit name (Unit) and a complete entity name (Typ) that
   --  resolves to denote a type declaration within Unit
   --  which declares the type that maps Node.

   function Calling_Stubs_Type
     (Self : access Mapping_Type;
      Node : Idl_Fe.Types.Node_Id)
     return String
      is abstract;
   --  Return the defining name for the calling stubs type
   --  corresponding to Node.

   function Generate_Scope_In_Child_Package
     (Self : access Mapping_Type;
      Node : Idl_Fe.Types.Node_Id)
     return Boolean
      is abstract;
   --  Given a Gen_Scope Node, return True if, and only if,
   --  the code generation for Node needs to occur in a new
   --  child unit.

private

   type Mapping_Type is abstract tagged null record;

end Ada_Be.Mappings;
