------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                          X E _ S T O R A G E S                           --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--         Copyright (C) 2008-2012, Free Software Foundation, Inc.          --
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

with XE_Utils; use XE_Utils;
with XE_Names; use XE_Names;

package body XE_Storages is

   -----------
   -- Equal --
   -----------

   function Equal (N1, N2 : Name_Id) return Boolean is
   begin
      return N1 = N2;
   end Equal;

   ----------
   -- Hash --
   ----------

   function Hash (N : Name_Id) return Hash_Header is
      Name : constant String  := Get_Name_String (N);
      H    : Natural          := 0;

   begin
      for J in Name'Range loop
         H := (H + Character'Pos (Name (J))) mod (Hash_Header'Last + 1);
      end loop;
      return H;
   end Hash;

   ----------------------
   -- Register_Storage --
   ----------------------

   procedure Register_Storage
     (Storage_Name     : String;
      Allow_Passive    : Boolean;
      Allow_Local_Term : Boolean;
      Need_Tasking     : Boolean)
   is
   begin
      Storage_Supports.Set
        (Id (Storage_Name),
         Storage_Support_Type'
           (Allow_Passive, Allow_Local_Term, Need_Tasking));
   end Register_Storage;

end XE_Storages;
