------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--          P O L Y O R B . T R A N S P O R T . D A T A G R A M             --
--                                                                          --
--                           S O C K E T S _ O U T                          --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2001-2002 Free Software Foundation, Inc.           --
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

--  Datagram Socket End Point to send data to network

with PolyORB.Sockets;
with PolyORB.Tasking.Mutexes;

package PolyORB.Transport.Datagram.Sockets_Out is

   pragma Elaborate_Body;

   use PolyORB.Sockets;

   End_Point_Write_Only : exception;

   ---------------
   -- End Point --
   ---------------

   type Socket_Out_Endpoint
     is new Datagram_Transport_Endpoint with private;
   --  Datagram Socket Access Point to send data

   procedure Create
     (TE   : in out Socket_Out_Endpoint;
      S    :        Socket_Type;
      Addr :        Sock_Addr_Type);

   function Create_Event_Source
     (TE : Socket_Out_Endpoint)
      return Asynch_Ev.Asynch_Ev_Source_Access;

   procedure Read
     (TE     : in out Socket_Out_Endpoint;
      Buffer : Buffers.Buffer_Access;
      Size   : in out Ada.Streams.Stream_Element_Count);
   --  Read data from datagram socket
   --  Socket is write-only, raise an exception

   procedure Write
     (TE     : in out Socket_Out_Endpoint;
      Buffer : Buffers.Buffer_Access);
   --  Write data to datagram socket

   procedure Close (TE : in out Socket_Out_Endpoint);

private

   type Socket_Out_Endpoint is new Datagram_Transport_Endpoint
     with record
        Socket : Socket_Type := No_Socket;
        Addr   : Sock_Addr_Type;
        Mutex  : Tasking.Mutexes.Mutex_Access;
     end record;

end PolyORB.Transport.Datagram.Sockets_Out;
