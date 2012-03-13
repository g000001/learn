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
end

defmodule M99Run do
  require M99
  Erlang.io.format("~w~n", [M99.listq [x, y, z]])
  Erlang.io.format("~w~n", [M99.listq [a, b, c]])

  x = 0
  Erlang.io.format("~w~n", [x])
  M99.inc1 x
  Erlang.io.format("~w~n", [x])
end
