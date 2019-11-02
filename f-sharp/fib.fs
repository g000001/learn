open System

(* fib  3:01am Saturday, 1 February 2014 *)


let rec fib n = if n < 2 then
                    n
                else fib(n - 1) + fib(n - 2)

(*
let rec fib n =
    match n with
    | 0 -> 0
    | 1 -> 1
    | _ -> fib (n - 1) + fib (n - 2)
*)

let main() =
    Console.WriteLine("fib 10: {0}", fib(10))
 
main()