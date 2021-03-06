------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                   A D A _ B E . T E M P O R A R I E S                    --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--         Copyright (C) 2001-2012, Free Software Foundation, Inc.          --
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

package Ada_Be.Temporaries is

   pragma Preelaborate;

   function T_Handler return String;
   function T_Returns return String;
   function T_Send_Request_Result return String;
   function T_Self_Ref return String;
   function T_Exception_Repo_Id return String;
   function T_Members return String;
   function T_Impl_Object_Ptr return String;
   function T_Value_Operation return String;

   function T_Request return String;
   function T_Ctx return String;
   function T_Argument return String;
   function T_Arg_Any return String;
   function T_Arg_CC return String;
   function T_Arg_List return String;
   function T_Arg_Name return String;
   function T_Content return String;
   function T_Excp_List return String;
   function T_Helpers return String;
   function T_Indices return String;
   function T_Lengths return String;
   function T_Ptr return String;
   function T_Result return String;
   function T_Result_Name return String;

   function T_J return String;

end Ada_Be.Temporaries;
