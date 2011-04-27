module: l99-10

define generic pack
    (sequence :: <sequence>)
 => (result :: <sequence>);

define method pack
    (sequence :: <string>)
 => (result :: <string>)
  if (sequence.empty?)
    sequence
  else
    join(sequence.pack1, ",")
  end if
end method pack;

define method pack
    (sequence :: <sequence>)
 => (result :: <sequence>)
  if (sequence.empty?)
    sequence
  else
    as(select (sequence by instance?)
         <list> => <list>;
         <vector> => <vector>;
       end select, sequence.pack1) 
  end if
end method pack;

define function pack1
    (sequence :: <sequence>)
 => (result :: <sequence>)
  let prev = sequence.first;
  let res = make(<deque>);
  let tem = make(<deque>);
  for (x in sequence)
    unless (x = prev)
      push-last(res, as(<list>, tem));
      tem := make(<deque>);
    end unless;
    push-last(tem, x);
    prev := x;
  end for;
  as(<list>, push-last(res, as(<list>, tem)));
end function pack1;

define generic join 
    (sequence :: <sequence>, delim :: <string>)
 => (result :: <sequence>);

define method join 
    (sequence :: <sequence>, delim :: <string>)
 => (result :: <string>)
  let result = make(<deque>);
  for (c in sequence)
    push-last(result, c);
    push-last(result, delim);
  finally
    result.pop-last;
    apply(concatenate-as, <string>, result);
  end for
end method join;

/////////////

define generic encode
    (sequence :: <sequence>)
 => (result :: <sequence>);

define method encode
    (sequence :: <list>)
 => (result :: <list>)
  as(<list>,next-method())
end method encode;

define method encode
    (sequence :: <vector>)
 => (result :: <vector>)
  as(<vector>,next-method())
end method encode;

define method encode
    (sequence :: <string>)
 => (result :: <string>)
  join(map(method(x)
               format-to-string("%d%s", x.size, x.first) 
           end,
           sequence.pack1),
       ";")
end method encode;

define method encode
    (sequence :: <sequence>)
 => (result :: <sequence>)
  map(method(x)list(x.size, x.first) end,
      sequence.pack1)
end method encode;

format-out("%=\n", #(a:, a:, a:, a:, b:, c:, c:, a:, a:, d:, e:, e:, e:, e:).encode);
format-out("%=\n", #[a:, a:, a:, a:, b:, c:, c:, a:, a:, d:, e:, e:, e:, e:].encode);

format-out("%=\n", "aaaabccaadeeee".encode);


//#(#(4, #"a"), #(1, #"b"), #(2, #"c"), #(2, #"a"), #(1, #"d"), #(4, #"e"))
//"4a;1b;2c;2a;1d;4e"

