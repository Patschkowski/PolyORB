------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--           P O L Y O R B . R E F E R E N C E S . B I N D I N G            --
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

--  Object references (binding operation).

--  $Id$

with PolyORB.Components;
with PolyORB.ORB;

package PolyORB.References.Binding is

   pragma Elaborate_Body;

   function Bind
     (R         : Ref;
      Local_ORB : ORB.ORB_Access)
     return Components.Component_Access;
   --  Bind R to a servant, and return that servant (or a surrogate
   --  thereof).
   --  Local_ORB is the local middleware. It is used to determine
   --  whether reference profiles are local. Its object adapter
   --  is queried to resolve local object ids into servants.
   --  When a remote reference is to be bound, Local_ORB is in
   --  charge of all the transport and communication aspects
   --  of the binding operation. It must then return a remote
   --  surrogate of the object designated by R.

   Invalid_Reference : exception;
   --  Raised when an attempt is made to bind a reference
   --  that is null or has no supported profile.

end PolyORB.References.Binding;
