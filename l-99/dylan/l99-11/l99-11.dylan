module: l99-11

/*
P11 (*) Modified run-length encoding.
    Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.

    Example:
    * (encode-modified '(a a a a b c c a a d e e e e))
    ((4 A) B (2 C) (2 A) D (4 E))
*/

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

define generic single?
    (sequence :: <sequence>)
 => (result :: <boolean>);

define method single?
    (sequence :: <sequence>)
 => (result :: <boolean>)
  ~sequence.empty? 
    & copy-sequence(sequence, start: 1).empty?
end method single?;

define generic encode-modified
    (sequence :: <sequence>)
 => (result :: <sequence>);

define method encode-modified
    (sequence :: <list>)
 => (result :: <list>)
  as(<list>, next-method())
end method encode-modified;

define method encode-modified
    (sequence :: <vector>)
 => (result :: <vector>)
  as(<vector>, next-method())
end method encode-modified;

define method encode-modified
    (sequence :: <string>)
 => (result :: <string>)
  join(map(method(x)
               if (x.single?)
                 x
               else
                 format-to-string("%d%s", x.size, x.first) 
               end if
           end,
           sequence.pack1),
       ";")
end method encode-modified;

define method encode-modified
    (sequence :: <sequence>)
 => (result :: <sequence>)
  map(method(x) 
          if (x.single?)
            x.first
          else
            list(x.size, x.first) 
          end if
      end,
      sequence.pack1)
end method encode-modified;

format-out("%=\n", #(a:, a:, a:, a:, b:, c:, c:, a:, a:, d:, e:, e:, e:, e:).encode-modified);
format-out("%=\n", #[a:, a:, a:, a:, b:, c:, c:, a:, a:, d:, e:, e:, e:, e:].encode-modified);

format-out("%=\n", "aaaabccaadeeee".encode-modified);

//format-out("%=\n", "aaaabccaadeeee".single?);
//format-out("%=\n", "a".single?);

//format-out("%=\n", #(a:).single?);

//format-out("%=\n", "".empty?);


//format-out("%=\n", copy-sequence("aaaabccaadeeee", start: 1).empty?);

//format-out("%=\n", "abccaadeeee"[1:3]);
//format-out("%=\n", "aaaabccaadeeee".encode-modified);



//#(#(4, #"a"), #(1, #"b"), #(2, #"c"), #(2, #"a"), #(1, #"d"), #(4, #"e"))
//"4a;1b;2c;2a;1d;4e"