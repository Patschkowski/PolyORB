------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
--              P O L Y O R B - T A S K I N G - M U T E X E S               --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--             Copyright (C) 1999-2002 Free Software Fundation              --
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
--              PolyORB is maintained by ENST Paris University.             --
--                                                                          --
------------------------------------------------------------------------------

--  Implementation of a POSIX-like mutexes

--  A complete implementation of this package is provided for all
--  tasking profiles.

--  $Id$

package PolyORB.Tasking.Mutexes is

   pragma Preelaborate;

   -------------
   -- Mutexes --
   -------------

   type Mutex_Type is abstract tagged limited private;
   type Mutex_Access is access all Mutex_Type'Class;
   --  Mutual exclusion locks (mutexes)  prevent  multiple  threads
   --  from  simultaneously  executing  critical  sections  of code
   --  which access shared data (that is, mutexes are used to seri-
   --  alize  the  execution of threads).

   procedure Enter (M : in out Mutex_Type)
      is abstract;
   --  A call to Enter locks the mutex object referenced by mp. If
   --  the mutex is already locked, the calling thread blocks until the
   --  mutex is freed; this will return with the mutex object
   --  referenced by mp in the locked state with the calling thread as
   --  its owner. If the current owner of a mutex tries to relock the
   --  mutex, it will result in deadlock.

   procedure Leave (M : in out Mutex_Type)
      is abstract;
   --  Leave is called by the owner of the mutex object referenced by
   --  mp to release it. The mutex must be locked and the calling
   --  thread must be the one that last locked the mutex (the owner).
   --  If there are threads blocked on the mutex object referenced by
   --  mp when Leave is called, the mp is freed, and the scheduling
   --  policy will determine which thread gets the mutex. If the
   --  calling thread is not the owner of the lock, the behavior of the
   --  program is undefined.

   -------------------
   -- Mutex_Factory --
   -------------------

   type Mutex_Factory_Type is abstract tagged limited null record;
   --  This type is a factory for the mutex type.
   --  A subclass of this factory exists for every tasking profile:
   --  Full Tasking, Ravenscar and No Tasking.
   --  This type provides functionalities for creating mutexes
   --  corresponding with the chosen tasking profile.

   type Mutex_Factory_Access is access all Mutex_Factory_Type'Class;

   function Create
     (MF   : access Mutex_Factory_Type;
      Name : String := "")
     return Mutex_Access
      is abstract;
   --  Create a new mutex, or get a preallocated one.
   --  Name will be used to get the configuration of this
   --  mutex from the configuration module.

   procedure Destroy
     (MF : in out Mutex_Factory_Type;
      M  : in out Mutex_Access)
     is abstract;
   --  Destroy M, or just release it if it was preallocated.

   function Get_Mutex_Factory
     return Mutex_Factory_Access;
   pragma Inline (Get_Mutex_Factory);
   --  Get the Mutex_Factory object registered in this package.

   procedure Register_Mutex_Factory
     (MF : Mutex_Factory_Access);
   --  Register the factory corresponding to the chosen tasking profile.

private

   type Mutex_Type is abstract tagged limited null record;

end PolyORB.Tasking.Mutexes;
