(* http://www.geocities.jp/m_hiroi/func/smlnj01.html *)

(* emacs: send-region c-c c-r *)

1+2*3;


1 + 1;
1 - ~1;

2 * ~1;

10 mod 3;

10.0 / 3.0;

10 div 3;

"Hello" ^ "," ^ " world";

1 = 1;


1 <> 1;

true andalso true;

true andalso false;

true andalso not false;

false orelse not false;


if true then 1
else 0

if false then 1
else 0

val a = 1

val a = (1, 2)

#1a

#2a

val lis = [1,2,3,4]

tl lis

hd lis

hd lis :: tl lis

[hd lis] @ tl lis

fun times2 (n) = n * 2

times2 8

fun fib (0, a1, a2) = a2
  | fib (1, a1, a2) = a1
  | fib (n, a1, a2) = fib (n - 1, a1 + a2, a1)

fib(40,1,0)

fun fact (n) = if n = 0 then 1
               else n * fact (n - 1)

fact 10



