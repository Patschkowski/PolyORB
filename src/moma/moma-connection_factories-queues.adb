package body MOMA.Connection_Factories.Queues is

   -----------------------
   --  Functions Create --
   -----------------------

   function Create return Connections.Queues.Queue is
      Temp : Connections.Queues.Queue;
   begin
      return Temp;
   end Create;

   function Create (Username : String; Password : String)
                   return Connections.Queues.Queue is
      Temp : Connections.Queues.Queue;
   begin
      pragma Warnings (Off);
      pragma Unreferenced (Username);
      pragma Unreferenced (Password);
      pragma Warnings (On);
      return Temp;
   end Create;

end MOMA.Connection_Factories.Queues;
