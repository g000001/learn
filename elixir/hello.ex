defmodule Hello do
 def world do
  Erlang.io.format("Hello, world.~n", [])
  Erlang.io.format("こんにちは、Erlangは日本語に難ありじゃなかったか。~n", [])
 end
end
Hello.world