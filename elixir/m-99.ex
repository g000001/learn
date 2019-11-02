# http://cl.cddddr.org/index.cgi?M-99

defmodule M99 do
  # 1.与えられた引数を全てQUOTEしてリストとして返すLISTQを作成せよ
  #   テーマ:引数のクォート
  # (listq a b c d e)
  # ≡ (list 'a 'b 'c 'd 'e)
  # ;=> (A B C D E)
  defmacro listq(args) do
    quote do: Enum.map (quote do: (unquote(args))), fn(x) ->
                elem x, 1
              end
  end

  # 2. INC1を作成せよ
  # テーマ:変数の捕捉
  defmacro inc1(var) do
    quote do: unquote(var) = unquote(var) + 1
  end


  # 3. Common LispのWHENを作成せよ
  # テーマ:制御構文の自作
  #
  # (my-when (< 1 2)
  #   (print "hello"))
  # ;->
  # ;   "hello"
  # ;=> "hello"
  defmacro my_when(pred, body) do
    quote do: if(unquote(pred), unquote(body))
  end


  # 4. Common LispのUNLESSを作成せよ
  #テーマ:制御構文の自作
  #
  #(my-unless (> 1 2)
  #  (print "hello"))
  #;->
  #;   "hello"
  #;=> "hello"
  defmacro my_unless(pred, body) do
    quote do: if(!unquote(pred), unquote(body))
  end


  defmacro let(spec, body) do
    [var, val] = spec
    quote do
       (fn(unquote(var)) ->
           unquote(body)
        end).(unquote(val))
    end
  end

  #条件が真の間だけボディ内を繰り返すWHILEを作成せよ
  #テーマ:繰り返し構文の自作
  #
  #(let ((i 0))
  #  (while (< i 10)
  #    (print i)
  #    (incf i)))
  #;->
  #;   0
  #;   1
  #;   2
  #;   3
  #;   4
  #;   5
  #;   6
  #;   7
  #;   8
  #;   9
  #;=> NIL
#  defmacro while(pred, body) do
#    {:loop,0,[(quote do: unquote(pred)),[{:do,nil},{:match,{:__kvblock__,0,[{[true],(quote do: unquote(body)) {:recur,0,(quote do: unquote(pred))}},{[false],nil}]}}]]}
#    quote do: loop(unquote(pred), match(__kvblock__, true, unquote(body), recur(unquote(pred))))
#  end

  #defmacro oneone do
  #  {:"+",0,[1,1]}
  #end

end

defmodule M99Run do
  require M99
  Erlang.io.format("~w~n", [M99.listq [x, y, z]])
  Erlang.io.format("~w~n", [M99.listq [a, b, c]])

  x = 0
  Erlang.io.format("~w~n", [x])
  M99.inc1 x
  Erlang.io.format("~w~n", [x])

  # 3
  M99.my_when true, do: IO.puts "when:yes"
  M99.my_when false, do: IO.puts "when:yes"

  # 4
  M99.my_unless true, do: IO.puts "unless:yes"
  M99.my_unless false, do: IO.puts "unless:yes"

  # 5
  #cnt = 10
  #M99.while cnt > 0, do: cnt = cnt +1


  M99.let [y, 2], do:
    M99.let [y, 3], do:
      Erlang.io.format("~w~n", [y])

  #IO.puts M99.oneone

end
