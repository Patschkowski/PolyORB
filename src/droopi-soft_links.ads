--  This package allows soft links to be defined and later called if they
--  have been installed. The purpose of this is to be able not to register
--  certain services that require tasking or other high-level features
--  in order to provide the user with a light run time system.

--  $Id$

package Droopi.Soft_Links is

   pragma Preelaborate;

   type Version_Id is mod 2 ** 8;
   No_Version : constant Version_Id := 0;

   function "<" (L, R : Version_Id) return Boolean;

   -------------------
   -- General types --
   -------------------

   type Parameterless_Procedure is access procedure;

   -------------------------------
   -- Critical section handling --
   -------------------------------

   procedure Register_Enter_Critical_Section
     (P : in Parameterless_Procedure);
   procedure Enter_Critical_Section;

   procedure Register_Leave_Critical_Section
     (P : in Parameterless_Procedure);
   procedure Leave_Critical_Section;

   -------------
   -- Barrier --
   -------------

   type Barrier_Type is abstract tagged null record;

   procedure Destroy (B : in out Barrier_Type) is abstract;

   procedure Signal
     (B : in Barrier_Type;
      N : in Positive := 1) is abstract;
   --  Release N processes waiting on the barrier.

   procedure Signal_All
     (B : in Barrier_Type;
      P : in Boolean := True) is abstract;
   --  Release all processes waiting on the barrier. If P is true,
   --  this barrier is no longer blocking.

   procedure Wait (B : in Barrier_Type) is abstract;

   type Barrier_Access is access all Barrier_Type'Class;

   type Barrier_Creation_Function is
     access function return Barrier_Access;

   procedure Register_Barrier_Creation_Function
     (F : in Barrier_Creation_Function);

   procedure Create (B : out Barrier_Access);
   pragma Inline (Create);

   procedure Destroy (B : in out Barrier_Access);
   pragma Inline (Destroy);

   procedure Signal
     (B : in Barrier_Access;
      N : in Positive := 1);
   pragma Inline (Signal);
   --  Release N processes waiting on the barrier.

   procedure Signal_All
     (B : in Barrier_Access;
      P : in Boolean := True);
   pragma Inline (Signal_All);
   --  Release all processes waiting on the barrier. If P is true,
   --  this barrier is no longer blocking.

   procedure Wait (B : in Barrier_Access);
   pragma Inline (Wait);

   -----------
   -- Mutex --
   -----------

   type Mutex_Type is abstract tagged null record;

   procedure Enter (M : in Mutex_Type) is abstract;

   procedure Destroy (M : in out Mutex_Type) is abstract;

   procedure Leave (M : in Mutex_Type) is abstract;

   type Mutex_Access is access all Mutex_Type'Class;

   type Mutex_Creation_Function is
     access function return Mutex_Access;

   procedure Register_Mutex_Creation_Function
     (F : in Mutex_Creation_Function);

   procedure Create (M : out Mutex_Access);
   pragma Inline (Create);

   procedure Enter (M : in Mutex_Access);
   pragma Inline (Enter);

   procedure Destroy (M : in out Mutex_Access);
   pragma Inline (Destroy);

   procedure Leave (M : in Mutex_Access);
   pragma Inline (Leave);

   -------------
   -- Watcher --
   -------------

   type Watcher_Type is abstract tagged null record;

   procedure Destroy (W : in out Watcher_Type) is abstract;

   procedure Differ
     (W : in Watcher_Type;
      V : in Version_Id) is abstract;
   --  Await until W version differs from V

   procedure Lookup
     (W : in Watcher_Type;
      V : out Version_Id) is abstract;
   --  Fetch W version

   procedure Update (W : in Watcher_Type) is abstract;
   --  Increment W version

   type Watcher_Access is access all Watcher_Type'Class;

   type Watcher_Creation_Function is
     access function return Watcher_Access;

   procedure Register_Watcher_Creation_Function
     (F : in Watcher_Creation_Function);

   procedure Create (W : out Watcher_Access);
   pragma Inline (Create);

   procedure Destroy (W : in out Watcher_Access);
   pragma Inline (Destroy);

   procedure Differ (W : in Watcher_Access; V : in Version_Id);
   pragma Inline (Differ);
   --  Await until W version differs from V

   procedure Lookup (W : in Watcher_Access; V : out Version_Id);
   pragma Inline (Lookup);
   --  Fetch W version

   procedure Update (W : in Watcher_Access);
   pragma Inline (Update);
   --  Increment W version

   --------------------
   -- Advanced Mutex --
   --------------------

   --  This is a classical mutual exclusion object except that when a
   --  task try to Enter a mutex several times without leaving it
   --  first it is not blocked and can continue. Leave keeps track of
   --  the number of times Enter has been successful.

   type Adv_Mutex_Type is abstract tagged null record;

   procedure Enter (M : in Adv_Mutex_Type) is abstract;

   procedure Destroy (M : in out Adv_Mutex_Type) is abstract;

   procedure Leave (M : in Adv_Mutex_Type) is abstract;

   type Adv_Mutex_Access is access all Adv_Mutex_Type'Class;

   type Adv_Mutex_Creation_Function is
     access function return Adv_Mutex_Access;

   procedure Register_Adv_Mutex_Creation_Function
     (F : in Adv_Mutex_Creation_Function);

   procedure Create (M : out Adv_Mutex_Access);
   pragma Inline (Create);

   procedure Enter (M : in Adv_Mutex_Access);
   pragma Inline (Enter);

   procedure Destroy (M : in out Adv_Mutex_Access);
   pragma Inline (Destroy);

   procedure Leave (M : in Adv_Mutex_Access);
   pragma Inline (Leave);

end Droopi.Soft_Links;
