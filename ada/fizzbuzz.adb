with Ada.Text_Io;
with Ada.Integer_Text_Io;

use Ada.Text_Io;

procedure Fizzbuzz is
begin
   for Idx in Integer range 1 .. 100 loop
      if Idx mod 15 = 0 then
         Put_Line("Fizz Buzz");
      elsif Idx mod 5 = 0 then
         Put_Line("Buzz");
      elsif Idx mod 3 = 0 then
         Put_Line("Fizz");
      else
         -- Ada.Integer_Text_Io.Put(Idx);
         Put(Idx);
         New_Line(1);
      end if;
   end loop;
end Fizzbuzz;
