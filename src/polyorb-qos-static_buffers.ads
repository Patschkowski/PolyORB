------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--         P O L Y O R B . Q O S . S T A T I C _ B U F F E R S              --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--           Copyright (C) 2007, Free Software Foundation, Inc.             --
--                                                                          --
-- PolyORB is free software; you  can  redistribute  it and/or modify it    --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. PolyORB is distributed  in the hope that it will be  useful,    --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with PolyORB; see file COPYING. If    --
-- not, write to the Free Software Foundation, 51 Franklin Street, Fifth    --
-- Floor, Boston, MA 02111-1301, USA.                                       --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--                  PolyORB is maintained by AdaCore                        --
--                     (email: sales@adacore.com)                           --
--                                                                          --
------------------------------------------------------------------------------

with PolyORB.Buffers;

package PolyORB.QoS.Static_Buffers is

   type QoS_GIOP_Static_Buffer_Parameter is
     new QoS_Parameter (GIOP_Static_Buffer) with
   record
      Buffer    : PolyORB.Buffers.Buffer_Access;
   end record;

   type QoS_GIOP_Static_Buffer_Parameter_Access is
     access all QoS_GIOP_Static_Buffer_Parameter'Class;

   procedure Release_Content
     (QoS : access QoS_GIOP_Static_Buffer_Parameter);

end PolyORB.QoS.Static_Buffers;