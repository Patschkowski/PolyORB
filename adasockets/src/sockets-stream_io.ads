-----------------------------------------------------------------------------
--                                                                         --
--                         ADASOCKETS COMPONENTS                           --
--                                                                         --
--                   S O C K E T S . S T R E A M _ I O                     --
--                                                                         --
--                                S p e c                                  --
--                                                                         --
--                        $ReleaseVersion: 0.1.0 $                         --
--                                                                         --
--                        Copyright (C) 1998-2000                          --
--             École Nationale Supérieure des Télécommunications           --
--                                                                         --
--   AdaSockets is free software; you can  redistribute it and/or modify   --
--   it  under terms of the GNU  General  Public License as published by   --
--   the Free Software Foundation; either version 2, or (at your option)   --
--   any later version.   AdaSockets is distributed  in the hope that it   --
--   will be useful, but WITHOUT ANY  WARRANTY; without even the implied   --
--   warranty of MERCHANTABILITY   or FITNESS FOR  A PARTICULAR PURPOSE.   --
--   See the GNU General Public  License  for more details.  You  should   --
--   have received a copy of the  GNU General Public License distributed   --
--   with AdaSockets; see   file COPYING.  If  not,  write  to  the Free   --
--   Software  Foundation, 59   Temple Place -   Suite  330,  Boston, MA   --
--   02111-1307, USA.                                                      --
--                                                                         --
--   As a special exception, if  other  files instantiate generics  from   --
--   this unit, or  you link this  unit with other  files to produce  an   --
--   executable,  this  unit does  not  by  itself cause  the  resulting   --
--   executable to be  covered by the  GNU General Public License.  This   --
--   exception does  not  however invalidate any  other reasons  why the   --
--   executable file might be covered by the GNU Public License.           --
--                                                                         --
--   The main repository for this software is located at:                  --
--       http://www.infres.enst.fr/ANC/                                    --
--                                                                         --
--   If you have any question, please send a mail to                       --
--       Samuel Tardieu <sam@inf.enst.fr>                                  --
--                                                                         --
-----------------------------------------------------------------------------

with Ada.Streams;

package Sockets.Stream_IO is

   type Socket_Stream_Type is new Ada.Streams.Root_Stream_Type with private;

   procedure Initialize
     (Stream : in out Socket_Stream_Type;
      FD     : in Socket_FD);
   --  Initialize must be called with an opened socket as parameter before
   --  being used as a stream.

   procedure Read
     (Stream : in out Socket_Stream_Type;
      Item   : out Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset);

   procedure Write
     (Stream : in out Socket_Stream_Type;
      Item   : in Ada.Streams.Stream_Element_Array);

private

   type Socket_Stream_Type is new Ada.Streams.Root_Stream_Type with record
      FD : Socket_FD;
   end record;

end Sockets.Stream_IO;
