--  Object adapters: entities that manage the association
--  of references with servants.

--  $Id$

with PolyORB.Any;
with PolyORB.Any.NVList;

with PolyORB.Components;
with PolyORB.Objects; use PolyORB.Objects;
with PolyORB.Requests;
with PolyORB.Smart_Pointers;

package PolyORB.Obj_Adapters is

   type Obj_Adapter is abstract new Smart_Pointers.Entity
     with private;
   type Obj_Adapter_Access is access all Obj_Adapter'Class;

   procedure Create (OA : access Obj_Adapter) is abstract;
   --  Initialize.

   procedure Destroy (OA : access Obj_Adapter) is abstract;
   --  Finalize.

   Invalid_Object_Id : exception;
   --  An invalid object identifier was passed to an object
   --  adapter subprogram.

   Invalid_Method : exception;
   --  A method was invoked on an object that does not implement it.

   procedure Set_ORB
     (OA      : access Obj_Adapter;
      The_ORB :        PolyORB.Components.Component_Access);
   --  Set the ORB whose OA is attached to.

   --------------------------------------
   -- Interface to application objects --
   --------------------------------------

   function Export
     (OA  : access Obj_Adapter;
      Obj : Objects.Servant_Access)
     return Object_Id is abstract;
   --  Create an identifier for Obj within OA.

   procedure Unexport
     (OA : access Obj_Adapter;
      Id : Object_Id) is abstract;
   --  Id is an object identifier attributed by OA.
   --  The corresponding association is suppressed.

   ----------------------------------------------------
   -- Interface to ORB (acting on behalf of clients) --
   ----------------------------------------------------

   function Get_Empty_Arg_List
     (OA     : access Obj_Adapter;
      Oid    : Object_Id;
      Method : Requests.Operation_Id)
     return Any.NVList.Ref is abstract;
   --  Return the paramter profile of the given method, so the
   --  protocol layer can unmarshall the message into a Request object.

   function Get_Empty_Result
     (OA     : access Obj_Adapter;
      Oid    : Object_Id;
      Method : Requests.Operation_Id)
     return Any.Any is abstract;
   --  Return the result profile of the given method.

   function Find_Servant
     (OA : access Obj_Adapter;
      Id : Object_Id)
     return Objects.Servant_Access is abstract;
   --  Retrieve the servant managed by OA for logical object Id.
   --  The servant that incarnates the object is return.

   procedure Release_Servant
     (OA : access Obj_Adapter;
      Id : Object_Id;
      Servant : in out Servant_Access) is abstract;
   --  Signal to OA that a Servant previously obtained using
   --  Find_Servant won't be used by the client anymore. This
   --  may cause the servant to be destroyed if so is OA's
   --  policy.

private

   type Obj_Adapter is abstract new Smart_Pointers.Entity with
      record
         ORB : PolyORB.Components.Component_Access;
         --  The ORB the OA is attached to. Needs to be casted into an
         --  ORB_Access when used.
      end record;

end PolyORB.Obj_Adapters;
