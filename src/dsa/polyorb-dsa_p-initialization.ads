------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--         P O L Y O R B . D S A _ P . I N I T I A L I Z A T I O N          --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2011-2012, Free Software Foundation, Inc.          --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.                                               --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
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

with PolyORB.Servants;

package PolyORB.DSA_P.Initialization is

   pragma Elaborate_Body;

   procedure Initiate_Well_Known_Service
     (S : PolyORB.Servants.Servant_Access; Name : String);
   --  Initiate a POA reachable by an absolute path of the form: /Name/ and
   --  which returns always the default servant S.
   --  Note: Name should start with an underscore to prevent clashes with user
   --  packages/types.

end PolyORB.DSA_P.Initialization;
