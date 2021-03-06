------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                  POLYORB.SECURITY.TRANSPORT_MECHANISMS                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2005-2012, Free Software Foundation, Inc.          --
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

--  CORBA CSI Version 2 Transport Mechanism configuration information

with PolyORB.Security.Credentials;
with PolyORB.Security.Types;
with PolyORB.Transport;
with PolyORB.Utils.Chained_Lists;

package PolyORB.Security.Transport_Mechanisms is

   package TAP_Lists is
     new PolyORB.Utils.Chained_Lists
     (PolyORB.Transport.Transport_Access_Point_Access,
      PolyORB.Transport."=");

   type Client_Transport_Mechanism is abstract tagged limited null record;

   type Client_Transport_Mechanism_Access is
     access all Client_Transport_Mechanism'Class;

   function Target_Supports
     (Mechanism : access Client_Transport_Mechanism)
      return PolyORB.Security.Types.Association_Options
      is abstract;

   function Target_Requires
     (Mechanism : access Client_Transport_Mechanism)
      return PolyORB.Security.Types.Association_Options
      is abstract;

   function Is_Supports
     (Mechanism   : access Client_Transport_Mechanism;
      Credentials :        PolyORB.Security.Credentials.Credentials_Ref)
      return Boolean is abstract;

   --  Return True iff Credentials supports the Mechanism

   type Target_Transport_Mechanism is abstract tagged limited record
      TAP : TAP_Lists.List;
   end record;

   type Target_Transport_Mechanism_Access is
     access all Target_Transport_Mechanism'Class;

   function Target_Supports
     (Mechanism : access Target_Transport_Mechanism)
      return PolyORB.Security.Types.Association_Options
      is abstract;

   function Target_Requires
     (Mechanism : access Target_Transport_Mechanism)
      return PolyORB.Security.Types.Association_Options
      is abstract;

   function Supported_Identity_Types
     (Mechanism : access Target_Transport_Mechanism)
      return PolyORB.Security.Types.Identity_Token_Type
      is abstract;

   function Supported_Naming_Mechanisms
     (Mechanism : access Target_Transport_Mechanism)
      return PolyORB.Security.Types.OID_Lists.List
      is abstract;

   procedure Set_Accepting_Credentials
     (Mechanism   : access Target_Transport_Mechanism;
      Credentials :        PolyORB.Security.Credentials.Credentials_Ref)
      is abstract;

end PolyORB.Security.Transport_Mechanisms;
