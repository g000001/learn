module: l99-04

format-out("%d\n", size("foo"));
format-out("%d\n", size(#(foo:, bar:, baz:)));
format-out("%d\n", size(#[foo:, bar:, baz:]));

define generic len
    (sequence :: <sequence>)
 => (result :: <integer>);

define method len
    (sequence :: <list>)
 => (result :: <integer>)
  if (empty?(sequence))
    0
  else
    1 + len(tail(sequence))
  end if
end method len;

define method LEN
    (sequence :: <sequence>)
 => (result :: <integer>)
  reduce(method(res, _) 1 + res end,
         0,
         sequence)
end method LEN;
  

format-out("%=",Foo:);
format-out("%d\n", len(#(foo:, bar:, baz:, quux:)));
//=> 4
format-out("%d\n", len("foo bar baz"));
//=> 11

format-out("%d\n", "foo bar baz quux".len);

format-out("%d\n", method(x) x end(33));

format-out("%=\n", #(foo:, bar:).len);
format-out("%=\n", #(foo:, bar:).tail.len);

/*
format-out("%d\n", method(x)
                       x + 1
                   end(33));

format-out("%d\n",
reduce1(method(x, y)
            format-out("%d\n",x);
            x + y
        end,
        #(1, 2, 3, 4, 5)));
*/