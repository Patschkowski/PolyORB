------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                        M O M A . S E S S I O N S                         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--             Copyright (C) 1999-2002 Free Software Fundation              --
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

--  $Id$

with MOMA.Messages.MArrays;
with MOMA.Messages.MBytes;
with MOMA.Messages.MRecords;
with MOMA.Messages.MStreams;
with MOMA.Messages.MTexts;
with MOMA.Types;

package MOMA.Sessions is

   ------------------------------
   --  Abstract Session Object --
   ------------------------------

   --   type Session is abstract tagged private;

   type Session is abstract tagged record
      Transacted : Boolean;
      Acknowledge_Mode : MOMA.Types.Acknowledge_Type;
   end record;

   procedure Close;

   procedure Commit;

   function Create_Byte_Message return MOMA.Messages.MBytes.MByte;

   function Create_Text_Message return MOMA.Messages.MTexts.MText;

   function Create_Text_Message (Value : MOMA.Types.String)
                                 return MOMA.Messages.MTexts.MText;

   function Create_Array_Message
     return MOMA.Messages.MArrays.MArray;

   function Create_Record_Message
     return MOMA.Messages.MRecords.MRecord;

   function Create_Stream_Message
     return MOMA.Messages.MStreams.MStream;

   function Get_Transacted return Boolean;

   procedure Recover;

   procedure Rollback;

private

end MOMA.Sessions;
