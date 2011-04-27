module: l99-01

//last(#(foo:, bar:, baz:));
//format-out("%s", "1");
//format-out("%s", foo:);
//format-out("%s", #"bar");

define method my-last (list)
  if (empty? list.tail)
    list;
  else
    my-last(list.tail);
  end if;
end function my-last;

let lst = #(foo:, bar:, baz:);
format-out("%=\n", my-last(lst));
format-out("Hello\n", my-last(lst));

// => #(#"baz")

// Invoke our main() function.
//main(application-name(), application-arguments());
