package body CORBA.Policy.Id_Uniqueness_Policy.Unique is

   use CORBA.Policy_Values;

   ------------
   -- Create --
   ------------

   function Create return Unique_Id_Policy_Access
   is
      Policy : Unique_Id_Policy_Access;
   begin
      Policy := new Unique_Id_Policy'(Policy_Type =>
                                        ID_UNIQUENESS_POLICY_ID,
                                      Value =>
                                        CORBA.Policy_Values.UNIQUE_ID);
      return Policy;
   end Create;

end CORBA.Policy.Id_Uniqueness_Policy.Unique;
