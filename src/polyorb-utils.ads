------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                        P O L Y O R B . U T I L S                         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                Copyright (C) 2001 Free Software Fundation                --
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

--  Miscellaneous utility subprograms.

--  $Id$

with Ada.Streams;

package PolyORB.Utils is

   pragma Pure;

   function Hex_Value (C : Character) return Integer;
   --  The integer value corresponding to hexadecimal digit C.
   --  If C is not a valid hexadecimal digit, Constraint_Error
   --  is raised.

   function To_String
     (A : Ada.Streams.Stream_Element_Array)
     return String;
   --  Return a string of hexadecimal digits representing the
   --  contents of A.

   function To_Stream_Element_Array
     (S : String)
     return Ada.Streams.Stream_Element_Array;
   --  Return the Stream_Element_Array represented by the
   --  string of hexadecimal digits contaned in S.

   function URI_Encode (S : String) return String;
   --  Return S with special characters replaced by
   --  "%" "hexdigit" "hexdigit" if these characters
   --  need to be escaped in URIs, except for spaces
   --  which are replaced by '+'.

   function URI_Decode (S : String) return String;
   --  Return S with any %xy sequence replaced with
   --  the character whose hexadecimal representation
   --  is xy, and any '+' characters replaced by spaces.

   function Trimmed_Image (I : Integer) return String;
   --  Return Integer'Image (I) without a leading space.

end PolyORB.Utils;
