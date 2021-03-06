------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--                POLYORB.OBJ_ADAPTERS.GROUP_OBJECT_ADAPTER                 --
--                                                                          --
--                                 B o d y                                  --
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

pragma Ada_2012;

--  Special Object Adapter to manage group servants

with PolyORB.Binding_Data;
with PolyORB.Log;
with PolyORB.Obj_Adapter_QoS;
with PolyORB.Servants.Group_Servants;
with PolyORB.Utils;

package body PolyORB.Obj_Adapters.Group_Object_Adapter is

   use PolyORB.Errors;
   use PolyORB.Log;
   use PolyORB.Tasking.Mutexes;

   package L is new PolyORB.Log.Facility_Log
     ("polyorb.obj_adapters.group_object_adapter");
   procedure O (Message : String; Level : Log_Level := Debug)
     renames L.Output;
   function C (Level : Log_Level := Debug) return Boolean
     renames L.Enabled;

   ------------
   -- Create --
   ------------

   overriding procedure Create (GOA : access Group_Object_Adapter) is
   begin
      Initialize (GOA.Registered_Groups);
      Create (GOA.Lock);
   end Create;

   -------------
   -- Destroy --
   -------------

   overriding procedure Destroy (GOA : access Group_Object_Adapter) is
   begin
      Finalize (GOA.Registered_Groups);
      Destroy (GOA.Lock);
      Destroy (Obj_Adapter (GOA.all)'Access);
   end Destroy;

   --------------------------------------
   -- Interface to application objects --
   --------------------------------------

   ------------
   -- Export --
   ------------

   overriding procedure Export
     (GOA   : access Group_Object_Adapter;
      Obj   :        Servants.Servant_Access;
      Key   :        Objects.Object_Id_Access;
      Oid   :    out Objects.Object_Id_Access;
      Error : in out PolyORB.Errors.Error_Container)
   is
      pragma Warnings (Off);
      pragma Unreferenced (Key);
      pragma Warnings (On);

      use PolyORB.Objects;
      use type PolyORB.Servants.Servant_Access;

      GS : PolyORB.Servants.Servant_Access;

   begin
      PolyORB.Servants.Group_Servants.Get_Group_Object_Id
        (Obj, Oid, Error);
      if Found (Error) then
         Throw (Error, NotAGroupObject_E, Null_Members'(Null_Member));
         return;
      end if;

      Enter (GOA.Lock);
      GS := Lookup (GOA.Registered_Groups, Image (Oid.all), null);
      if GS /= null then
         pragma Debug (C, O ("Group "
                          & Image (Oid.all)
                          & " has been registered before"));
         Throw (Error, NotAGroupObject_E, Null_Members'(Null_Member));
         --  XXX Need to add a GroupAlreadyRegistered exception ?

      else
         --  Register the group

         pragma Debug
           (C, O ("Group servant : " & Image (Oid.all) & " exported"));
         Insert (GOA.Registered_Groups, Image (Oid.all), Obj);
         PolyORB.Servants.Set_Executor (Obj, GOA.S_Exec'Access);
         --  XXX questionable
      end if;
      Leave (GOA.Lock);
   end Export;

   --------------
   -- Unexport --
   --------------

   overriding procedure Unexport
     (GOA   : access Group_Object_Adapter;
      Id    :        Objects.Object_Id_Access;
      Error : in out PolyORB.Errors.Error_Container)
   is
      use PolyORB.Objects;
      use PolyORB.Servants.Group_Servants;
      use type PolyORB.Servants.Servant_Access;

      GS : PolyORB.Servants.Servant_Access;

   begin
      Enter (GOA.Lock);

      GS := Lookup (GOA.Registered_Groups, Oid_To_Hex_String (Id.all), null);

      if GS = null then
         pragma Debug (C, O ("Invalid group : " & Oid_To_Hex_String (Id.all)));
         Throw (Error,
                Invalid_Object_Id_E,
                Null_Members'(Null_Member));
      else
         Destroy_Group_Servant (GS);
         Delete (GOA.Registered_Groups, Oid_To_Hex_String (Id.all));
         pragma Debug (C, O ("Group removed with success : "
                          & Oid_To_Hex_String (Id.all)));
      end if;

      Leave (GOA.Lock);
   end Unexport;

   ----------------
   -- Object_Key --
   ----------------

   overriding procedure Object_Key
     (GOA     : access Group_Object_Adapter;
      Id      :        Objects.Object_Id_Access;
      User_Id :    out Objects.Object_Id_Access;
      Error   : in out PolyORB.Errors.Error_Container)
   is
      pragma Warnings (Off);
      pragma Unreferenced (GOA, Id);
      pragma Warnings (On);

   begin
      --  No user id in this OA
      User_Id := null;

      Throw (Error,
             Invalid_Object_Id_E,
             Null_Members'(Null_Member));
   end Object_Key;

   -------------
   -- Get_QoS --
   -------------

   overriding procedure Get_QoS
     (OA    : access Group_Object_Adapter;
      Id    :        Objects.Object_Id;
      QoS   :    out PolyORB.QoS.QoS_Parameters;
      Error : in out PolyORB.Errors.Error_Container)
   is
      pragma Unreferenced (Id);
      pragma Unreferenced (Error);
   begin
      QoS := PolyORB.Obj_Adapter_QoS.Get_Object_Adapter_QoS (OA);
   end Get_QoS;

   ----------------------------------------------------
   -- Interface to ORB (acting on behalf of clients) --
   ----------------------------------------------------

   ------------------------
   -- Get_Empty_Arg_List --
   ------------------------

   overriding function Get_Empty_Arg_List
     (GOA    : access Group_Object_Adapter;
      Oid    : access Objects.Object_Id;
      Method :        String)
      return Any.NVList.Ref
   is
      pragma Warnings (Off);
      pragma Unreferenced (GOA, Oid, Method);
      pragma Warnings (On);

      Result : Any.NVList.Ref;

   begin
      pragma Debug (C, O ("Get empty args list called, return empty list"));
      return Result;
   end Get_Empty_Arg_List;

   ----------------------
   -- Get_Empty_Result --
   ----------------------

   overriding function Get_Empty_Result
     (GOA    : access Group_Object_Adapter;
      Oid    : access Objects.Object_Id;
      Method :        String)
      return Any.Any
   is
      pragma Warnings (Off);
      pragma Unreferenced (GOA, Oid, Method);
      pragma Warnings (On);

      Result : Any.Any;

   begin
      pragma Debug (C, O ("Get empty result list called, return no type"));
      return Result;
   end Get_Empty_Result;

   ------------------
   -- Find_Servant --
   ------------------

   overriding procedure Find_Servant
     (GOA     : access Group_Object_Adapter;
      Id      : access Objects.Object_Id;
      Servant :    out Servants.Servant_Access;
      Error   : in out PolyORB.Errors.Error_Container)
   is
      use PolyORB.Objects;
      use type PolyORB.Servants.Servant_Access;

   begin
      pragma Debug (C, O ("Find_Servant " & Image (Id.all)));

      Enter (GOA.Lock);

      Servant := Lookup (GOA.Registered_Groups, Image (Id.all), null);
      if Servant = null then
         pragma Debug (C, O ("Servant not found"));
         Throw (Error,
                Invalid_Object_Id_E,
                Null_Members'(Null_Member));
      else
         pragma Debug (C, O ("Servant found"));
         null;
      end if;

      Leave (GOA.Lock);
   end Find_Servant;

   ---------------------
   -- Release_Servant --
   ---------------------

   overriding procedure Release_Servant
     (GOA     : access Group_Object_Adapter;
      Id      : access Objects.Object_Id;
      Servant : in out Servants.Servant_Access)
   is
      pragma Warnings (Off);
      pragma Unreferenced (GOA, Id);
      pragma Warnings (On);

   begin
      --  Nothing to do

      Servant := null;
   end Release_Servant;

   ---------------
   -- Get_Group --
   ---------------

   function Get_Group
     (The_Ref              : PolyORB.References.Ref;
      Allow_Group_Creation : Boolean := False)
     return PolyORB.Servants.Servant_Access
   is
      use PolyORB.Binding_Data;
      use PolyORB.Objects;
      use PolyORB.References;
      use PolyORB.Smart_Pointers;

      Profs : constant Profile_Array
        := Profiles_Of (The_Ref);
      Error : Error_Container;
      GS : PolyORB.Servants.Servant_Access;

   begin
      pragma Debug (C, O ("Get group from reference"));

      for J in Profs'Range loop
         declare
            OA_Entity : constant PolyORB.Smart_Pointers.Entity_Ptr :=
              Get_OA (Profs (J).all);
         begin
            if OA_Entity /= null
              and then OA_Entity.all in Group_Object_Adapter'Class
            then
               pragma Debug (C, O ("Searching group using a group profile"));

               Find_Servant
                 (Group_Object_Adapter (OA_Entity.all)'Access,
                  Get_Object_Key (Profs (J).all),
                  GS,
                  Error);

               if not Found (Error) then
                  pragma Debug (C, O ("Group found"));
                  return GS;
               end if;

               if Allow_Group_Creation then
                  pragma Debug (C, O ("Create a new group"));
                  GS := PolyORB.Servants.Group_Servants.Create_Group_Servant
                    (Get_Object_Key (Profs (J).all));

                  declare
                     Oid   : Object_Id_Access;
                     Error : Error_Container;
                  begin
                     Export
                       (Group_Object_Adapter (OA_Entity.all)'Access,
                        GS,
                        null,
                        Oid,
                        Error);

                     if Found (Error)
                       or else Oid.all /= Get_Object_Key (Profs (J).all).all
                     then
                        pragma Debug (C, O ("Exporting group error"));
                        return null;
                     end if;

                     pragma Debug (C, O ("Group Exported"));
                     return GS;
                  end;
               end if;
            end if;
         end;
      end loop;

      pragma Debug (C, O ("Group not found"));
      return null;
   end Get_Group;

end PolyORB.Obj_Adapters.Group_Object_Adapter;
