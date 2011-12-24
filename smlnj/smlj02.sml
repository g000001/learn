(* http://www.geocities.jp/m_hiroi/func/smlnj02.html *)

let
    val x = 3
    val y = 4
in
    x::y::nil
end

let
    fun foo (n) = n
in
    foo 8
end

let
    fun pow (base, p) = if p = 0 then 1
                        else base * pow (base, p - 1)
in
    pow(2, 3)
end


(* 多相型 *)

(* ex my_length *)
fun my_length (list) = if null list then 0
                       else 1 + my_length (tl list)

(*
val my_length = fn : 'a list -> int
val it = () : unit
 *)

my_length [1,2,3,4]

my_length ["foo", "bar", "baz"]

(* ex. append *)
fun append (x, y) = if null x then y
                    else (hd x) :: append(tl x, y)

append([1,2,3,4],[1,2,3,4])

rev[1,2,3,4]

(* ex. reverse *)
fun reverse (list) = if null list then []
                     else reverse(tl list) @ [hd list]

reverse[1,2,3,4];

(* ex. member *)

fun member (item, list) =
    if null (list) then []
    else if hd(list) = item then list
    else member(item, tl(list))

member (1,[3,4,5,2,1,3])


let
    val (x, y)::tail = [(1,2),(3,4)]
in
    (y,x)::tail
end

(* ex. qsort *)
fun partition (item, [], a1, a2) = (a1, a2)
  | partition (item, x::xs, a1, a2)
    = if item <= x then partition (item, xs, a1, x::a2)
      else partition (item, xs, x::a1, a2)

partition (3,[1,2,3,4,5,6,7],[],[])


fun qsort ([]) = []
  | qsort (x::xs)
    = let
        val (le, gt) = partition (x, xs, [], [])
    in
        qsort (le) @ [x] @ qsort (gt)
    end

(* 下記のようにすると引数が2つにできる *)
fun partition (item, []) = (nil, nil)
  | partition (item, x::xs) =
    let
        val (le, gt) = partition (item, xs)
    in
        if item <= x then (le, x::gt)
        else (x::le, gt)
    end

partition (3,[1,2,3,4,5,6,7])


fun qsort ([]) = []
  | qsort (x::xs)
    = let
        val (le, gt) = partition (x, xs)
    in
        qsort (le) @ [x] @ qsort (gt)
    end

qsort[]
qsort[3,21,333,4,1,5]


fun foo( 0 ) = true
|   foo( n ) = bar( n - 1 )
and
    bar( 0 ) = false
|   bar( n ) = foo( n - 1 )


foo(10)










