------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                 P O L Y O R B . D Y N A M I C _ D I C T                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                Copyright (C) 2001 Free Software Fundation                --
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
--              PolyORB is maintained by ENST Paris University.             --
--                                                                          --
------------------------------------------------------------------------------

--  A dynamic, protected  dictionnary of objects, indexed by Strings.

--  $Id$

--  generic

--  type Value is private;
--  No_Value : Value;

with MOMA.Types;
with PolyORB.Utils.HTables.Perfect;
with PolyORB.Locks;

package MOMA.Message_Pool.Warehouse is

   package Perfect_Htable is
      new PolyORB.Utils.HTables.Perfect (MOMA.Types.String);

   use Perfect_Htable;

   type Warehouse is record
      T : Table_Instance;
      T_Initialized : Boolean := False;
      T_Lock : PolyORB.Locks.Rw_Lock_Access;
   end record;

   Key_Not_Found : exception;

   procedure Ensure_Initialization (W : in out Warehouse);
   pragma Inline (Ensure_Initialization);
   --  Ensure that T was initialized

   procedure Register
     (W : Warehouse;
      K : String;
      V : MOMA.Types.String);
   --  Associate key K with value V.

   procedure Unregister
     (W : Warehouse;
      K : String);
   --  Remove any association for K. Key_Not_Found is raised
   --  if no value was registered for this key.

   function Lookup
      (W : Warehouse;
       K : String)
     return MOMA.Types.String;
   --  Lookup K in the dictionary, and return the associated value.
   --  Key_Not_Found is raised if no value was registered for this
   --  key.

   function Lookup
     (W : Warehouse;
      K : String;
      Default : MOMA.Types.String)
     return MOMA.Types.String;
   --  As above, but Default is returned for non-registered keys,
   --  insted of raising an exception.

end MOMA.Message_Pool.Warehouse;
