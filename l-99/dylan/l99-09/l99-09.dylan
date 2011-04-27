module: l99-09

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

/*
define function sein
    (sequence :: <sequence>)
 => (type)
  format-out("hello!\n");
  select (sequence by instance?)
    <list> => <list>;
    <string> => <string>;
    <vector> => <vector>;
  end select; 
end function sein;
*/

/*
(my-pack '(a a a a b c c a a d e e e e))
;=> ((a a a a) (b) (c c) (a a) (d) (e e e e))
(my-pack #(a a a a b c c a a d e e e e))
;=> #((a a a a) (b) (c c) (a a) (d) (e e e e))
(my-pack #[a a a a b c c a a d e e e e])
;=> #[(a a a a) (b) (c c) (a a) (d) (e e e e)]
(my-pack "aaaabccaadeeee")
;=> "aaaa,b,cc,aa,d,eeee"
*/

format-out("%=\n", #().pack);
format-out("%=\n", #[].pack);

format-out("%=\n", #(a:, a:, a:, a:, b:, c:, c:, a:, a:, d:, e:, e:, e:, e:).pack);
format-out("%=\n", #[a:, a:, a:, a:, b:, c:, c:, a:, a:, d:, e:, e:, e:, e:].pack);
format-out("%=\n", "aaaabccaadeeee".pack);

/*
#(#(#"a", #"a", #"a", #"a"), #(#"b"), #(#"c", #"c"), #(#"a", #"a"), #(#"d"), #(#"e", #"e", #"e", #"e"))
#[#(#"a", #"a", #"a", #"a"), #(#"b"), #(#"c", #"c"), #(#"a", #"a"), #(#"d"), #(#"e", #"e", #"e", #"e")]
"aaaa,b,cc,aa,d,eeee"
*/
