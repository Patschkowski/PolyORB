------------------------------------------------------------------------------
--                                                                          --
--                          ADABROKER COMPONENTS                            --
--                                                                          --
--                         C O R B A . O B J E C T                          --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1999-2001 ENST Paris University, France.          --
--                                                                          --
-- AdaBroker is free software; you  can  redistribute  it and/or modify it  --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. AdaBroker  is distributed  in the hope that it will be  useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with AdaBroker; see file COPYING. If  --
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
--             AdaBroker is maintained by ENST Paris University.            --
--                     (email: broker@inf.enst.fr)                          --
--                                                                          --
------------------------------------------------------------------------------

with Broca.Debug;
with Broca.CDR;
with Broca.Opaque;            use Broca.Opaque;

package body CORBA.Fixed_Point is

   -----------
   -- Debug --
   -----------

   Flag : constant Natural
     := Broca.Debug.Is_Active ("corba.fixed_point");
   procedure O is new Broca.Debug.Output (Flag);

   ---------------------
   -- this is to help --
   ---------------------
   package CDR_Fixed_F is
      new Broca.CDR.Fixed_Point (F);


   --------------
   --  To_Any  --
   --------------
   function To_Any (Item : in F) return Any is
      Tco : CORBA.TypeCode.Object;
   begin
      CORBA.TypeCode.Set_Kind (Tco, Tk_Fixed);
      CORBA.TypeCode.Add_Parameter
        (Tco, To_Any (CORBA.Unsigned_Short (F'Digits)));
      CORBA.TypeCode.Add_Parameter (Tco, To_Any (CORBA.Short (F'Scale)));
      declare
         Result : Any := CORBA.Get_Empty_Any_Aggregate (Tco);
         Octets : Octet_Array := CDR_Fixed_F.Fixed_To_Octets (Item);
      begin
         for I in Octets'Range loop
            CORBA.Add_Aggregate_Element
              (Result,
               CORBA.To_Any (CORBA.Octet (Octets (I))));
         end loop;
         return Result;
      end;
   end To_Any;

   ----------------
   --  From_Any  --
   ----------------
   function From_Any (Item : in Any) return F is
   begin
      pragma Debug (O ("From_Any (Fixed) : enter"));
      if (TypeCode.Kind (Get_Precise_Type (Item)) /= Tk_Fixed) then
         pragma Debug
           (O ("From_Any (Fixed) : Bad_TypeCode, type is " &
               CORBA.TCKind'Image
               (TypeCode.Kind (Get_Precise_Type (Item)))));
         raise Bad_TypeCode;
      end if;
      declare
         Nb : CORBA.Unsigned_Long := CORBA.Get_Aggregate_Count (Item);
         Octets : Octet_Array (1 .. Index_Type (Nb)) := (others => 0);
      begin
         for I in Octets'Range loop
            pragma Debug (O ("From_Any (Fixed) : yet another octet"));
            declare
               Element : CORBA.Any :=
                 CORBA.Get_Aggregate_Element (Item,
                                              CORBA.TC_Octet,
                                              CORBA.Unsigned_Long (I - 1));
            begin
               pragma Debug (O ("From_Any (Fixed) : Store it"));
               Octets (I) := Broca.Opaque.Octet
                 (CORBA.Octet'(CORBA.From_Any (Element)));
            end;
         end loop;
         pragma Debug (O ("From_Any (Fixed) : return"));
         return CDR_Fixed_F.Octets_To_Fixed (Octets);
      exception when CORBA.Marshal =>
         pragma Debug (O ("From_Any (Fixed) : exception catched" &
                          "while returning"));
         raise CORBA.Bad_TypeCode;
      end;
   end From_Any;

end CORBA.Fixed_Point;

