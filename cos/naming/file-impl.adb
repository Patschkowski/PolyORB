------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                            F I L E . I M P L                             --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--            Copyright (C) 2001 Free Software Foundation, Inc.             --
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

--  $Id$

with CORBA;
pragma Elaborate_All (CORBA);
with CORBA.ORB;
pragma Elaborate_All (CORBA.ORB);
with PortableServer.POA;
pragma Elaborate_All (PortableServer.POA);

with File.Skel;
pragma Elaborate (File.Skel);
pragma Warnings (Off, File.Skel);
with File.Helper;

package body File.Impl is

   type File_Ptr is access all Object'Class;

   Root_POA_String : constant CORBA.String
     := CORBA.To_CORBA_String ("RootPOA");

   Root_POA : PortableServer.POA.Ref;

   function Get_Root_POA return PortableServer.POA.Ref;

   function Get_Root_POA return PortableServer.POA.Ref is
   begin
      if PortableServer.POA.Is_Nil (Root_POA) then
         Root_POA := PortableServer.POA.To_Ref
          (CORBA.ORB.Resolve_Initial_References
           (CORBA.ORB.ObjectId (Root_POA_String)));
      end if;
      return Root_POA;
   end Get_Root_POA;

   function New_File
     return File.Ref
   is
      Obj : constant File_Ptr
        := new Object;

      Oid : constant PortableServer.ObjectId
        := PortableServer.POA.Activate_Object
        (Get_Root_POA, PortableServer.Servant (Obj));
      pragma Warnings (Off, Oid);
      --  Not referenced (created in order to
      --  evaluate the effects of Activate_Object).
   begin
      return File.Helper.To_Ref
        (PortableServer.POA.Servant_To_Reference
         (Get_Root_POA, PortableServer.Servant (Obj)));
   end New_File;

   function get_Image
     (Self : access Object)
     return CORBA.String is
   begin
      return Self.Image;
   end get_Image;

   procedure set_Image
     (Self : access Object;
      To : in CORBA.String) is
   begin
      Self.Image := To;
   end set_Image;

end File.Impl;