with Broca.Exceptions;
with Broca.Soft_Links;
with Ada.Characters.Handling;
with CORBA;

--  A store to register operations with RepositoryIds

package body Broca.Operation_Store is

   type Operation_Store;
   type Operation_Store_Ptr is access all Operation_Store'Class;

   type Operation_Store is tagged record
      RepoId : CORBA.RepositoryId;
      Operation : Operation_Type;
      Next : Operation_Store_Ptr;
   end record;

   The_Store : Operation_Store_Ptr := null;

   --------------------
   --  Is_Equivalent --
   --------------------
   function Is_Equivalent
     (RI1 : in CORBA.RepositoryId;
      RI2 : in CORBA.RepositoryId)
      return Boolean;
   --  copied from broca.Repository to avaoid circular
   --  dependancy
   function Is_Equivalent
     (RI1 : in CORBA.RepositoryId;
      RI2 : in CORBA.RepositoryId)
      return Boolean
   is
      use CORBA;
      use Ada.Characters.Handling;
   begin
      return To_Lower (To_Standard_String (RI1))
        = To_Lower (To_Standard_String (RI2));
   end Is_Equivalent;


   ------------------------
   -- Register_Operation --
   ------------------------

   procedure Register_Operation
     (RepoId : in Standard.String;
      Op : in Operation_Type) is
      S : constant CORBA.String
        := CORBA.To_CORBA_String (RepoId);
   begin
      Register_Operation
        (CORBA.RepositoryId (S), Op);
   end Register_Operation;

   procedure Register_Operation
     (RepoId : in CORBA.RepositoryId;
      Op : in Operation_Type) is
   begin
      Broca.Soft_Links.Enter_Critical_Section;
      The_Store := new Operation_Store'
        (RepoId => RepoId,
         Operation => Op,
         Next => The_Store);
      Broca.Soft_Links.Leave_Critical_Section;
   end Register_Operation;

   -------------------
   -- Get_Operation --
   -------------------

   function Get_Operation
     (RepoId : in Standard.String)
      return Operation_Type is
      S : constant CORBA.String := CORBA.To_CORBA_String (RepoId);
   begin
      return Get_Operation (CORBA.RepositoryId (S));
   end Get_Operation;


   function Get_Operation
     (RepoId : in CORBA.RepositoryId)
      return Operation_Type is
      Temp : Operation_Store_Ptr;
   begin
      Temp := The_Store;
      Broca.Soft_Links.Enter_Critical_Section;
      while Temp /= null loop
         exit when Is_Equivalent (Temp.RepoId, RepoId);
         Temp := Temp.Next;
      end loop;
      if Temp = null then
         Broca.Exceptions.Raise_Internal;
      end if;
      Broca.Soft_Links.Leave_Critical_Section;
      return Temp.Operation;
   end Get_Operation;

end Broca.Operation_Store;
