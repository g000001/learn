(* fibonacci *)

fun fib (0) = 0
  | fib (1) = 1
  | fib (n) = fib (n - 1) + fib (n - 2)


(* 時間計測用 *)
fun fib_exec( x ) =
  let
    val a = Timer.startRealTimer()
  in
    fib( x );
    Timer.checkRealTimer( a )
  end

