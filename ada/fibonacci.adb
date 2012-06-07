with Ada.Integer_Text_Io;
use Ada.Integer_Text_Io;

package body Fibonacci is
   procedure Fibonacci is
   begin
      Put(Fib(20));
   end;

   function Fib(N : Integer) return Integer is
   begin
      if N < 2 then
         return N;
      else
         return Fib(N - 2) + Fib(N - 1);
      end if;
   end Fib;
end Fibonacci;
