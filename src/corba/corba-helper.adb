------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                         C O R B A . H E L P E R                          --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2002-2004 Free Software Foundation, Inc.           --
--                                                                          --
-- PolyORB is free software; you  can  redistribute  it and/or modify it    --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. PolyORB is distributed  in the hope that it will be  useful,    --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with PolyORB; see file COPYING. If    --
-- not, write to the Free Software Foundation, 59 Temple Place - Suite 330, --
-- Boston, MA 02111-1307, USA.                                              --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--                PolyORB is maintained by ACT Europe.                      --
--                    (email: sales@act-europe.fr)                          --
--                                                                          --
------------------------------------------------------------------------------

--  $Id: //droopi/main/src/corba/corba-helper.adb#5 $

with PolyORB.Initialization;
with PolyORB.Utils.Strings;

package body CORBA.Helper is

   ----------------------
   -- TC_Repository_Id --
   ----------------------

   TC_RepositoryId_Cache : CORBA.TypeCode.Object;

   function TC_RepositoryId return CORBA.TypeCode.Object is
   begin
      return TC_RepositoryId_Cache;
   end TC_RepositoryId;

   --------------
   -- From_Any --
   --------------

   function From_Any (Item : in CORBA.Any)
      return CORBA.RepositoryId is
      Result : CORBA.String := CORBA.From_Any (Item);
   begin
      return CORBA.RepositoryId (Result);
   end From_Any;

   ------------
   -- To_Any --
   ------------

   function To_Any
     (Item : in CORBA.RepositoryId)
     return CORBA.Any is
      Result : CORBA.Any := CORBA.To_Any (CORBA.String (Item));
   begin
      CORBA.Set_Type (Result, TC_RepositoryId);
      return Result;
   end To_Any;

   -------------------
   -- TC_Identifier --
   -------------------

   TC_Identifier_Cache : CORBA.TypeCode.Object;

   function TC_Identifier return CORBA.TypeCode.Object is
   begin
      return TC_Identifier_Cache;
   end TC_Identifier;

   --------------
   -- From_Any --
   --------------

   function From_Any (Item : in CORBA.Any)
      return CORBA.Identifier is
      Result : CORBA.String := CORBA.From_Any (Item);
   begin
      return CORBA.Identifier (Result);
   end From_Any;

   ------------
   -- To_Any --
   ------------

   function To_Any
     (Item : in CORBA.Identifier)
     return CORBA.Any is
      Result : CORBA.Any := CORBA.To_Any (CORBA.String (Item));
   begin
      CORBA.Set_Type (Result, TC_Identifier);
      return Result;
   end To_Any;

   -------------------
   -- TC_ScopedName --
   -------------------

   TC_ScopedName_Cache : CORBA.TypeCode.Object;

   function TC_ScopedName return CORBA.TypeCode.Object is
   begin
      return TC_ScopedName_Cache;
   end TC_ScopedName;

   --------------
   -- From_Any --
   --------------

   function From_Any (Item : in CORBA.Any)
      return CORBA.ScopedName is
      Result : CORBA.String := CORBA.From_Any (Item);
   begin
      return CORBA.ScopedName (Result);
   end From_Any;

   ------------
   -- To_Any --
   ------------

   function To_Any
     (Item : in CORBA.ScopedName)
     return CORBA.Any is
      Result : CORBA.Any := CORBA.To_Any (CORBA.String (Item));
   begin
      CORBA.Set_Type (Result, TC_ScopedName);
      return Result;
   end To_Any;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize;

   procedure Initialize is
      use CORBA.TypeCode;

      function Build_TC_Alias_String
        (Name : Standard.String)
         return CORBA.TypeCode.Object;
      --  Build a typecode for type Name which is an alias of CORBA::String

      function Build_TC_Alias_String
        (Name : Standard.String)
         return CORBA.TypeCode.Object
      is
         TC : CORBA.TypeCode.Object
           := TypeCode.Internals.To_CORBA_Object
           (PolyORB.Any.TypeCode.TC_Alias);

      begin
         TypeCode.Internals.Add_Parameter
           (TC, CORBA.To_Any (To_CORBA_String (Name)));
         TypeCode.Internals.Add_Parameter
           (TC, CORBA.To_Any (To_CORBA_String
                              ("IDL:omg.org/CORBA/" & Name & ":1.0")));
         TypeCode.Internals.Add_Parameter
           (TC, CORBA.To_Any (CORBA.TC_String));
         return TC;
      end Build_TC_Alias_String;

   begin
      TC_RepositoryId_Cache := Build_TC_Alias_String ("RepositoryId");
      TC_Identifier_Cache := Build_TC_Alias_String ("Identifier");
      TC_ScopedName_Cache := Build_TC_Alias_String ("ScopedName");
   end Initialize;

   use PolyORB.Initialization;
   use PolyORB.Initialization.String_Lists;
   use PolyORB.Utils.Strings;

begin
   Register_Module
     (Module_Info'
      (Name      => +"corba.helper",
       Conflicts => Empty,
       Depends   => +"corba" & "any",
       Provides  => Empty,
       Implicit  => False,
       Init      => Initialize'Access));
end CORBA.Helper;