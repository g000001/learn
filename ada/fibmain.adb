with Ada.Integer_Text_Io, Fibonacci;
use Ada.Integer_Text_Io;

procedure Fibmain is
begin
   Put(Fibonacci.Fib(40));
end Fibmain;

-- time ./fibmain
--   102334155
-- 3.188 secs
