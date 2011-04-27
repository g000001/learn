module: l99-05

define generic rev 
    (sequence :: <sequence>)
 => (result :: <sequence>);

/*
define method rev
    (sequence :: <list>)
 => (result :: <list>)
  if (sequence.empty?)
    sequence
  else
    concatenate(sequence.tail.rev, sequence.head.list);
  end if;
end method rev;

define method rev
    (sequence :: <list>)
 => (result :: <sequence>)
  let result = make(<deque>);
  for (elt in sequence)
    push(result, elt);
  finally as(<list>, result)
  end for
end method rev;

define method rev
    (sequence :: <string>)
 => (result :: <sequence>)
  let result = make(<deque>);
  for (elt in sequence)
    push(result, elt);
  finally as(<string>, result)
  end for
end method rev;

define method rev
    (sequence :: <vector>)
 => (result :: <sequence>)
  let result = make(<deque>);
  for (elt in sequence)
    push(result, elt);
  finally as(<vector>, result)
  end for
end method rev;
*/

define method rev
    (sequence :: <sequence>)
 => (result :: <sequence>)
  let result = make(<deque>);
  for (elt in sequence)
    push(result, elt);
  finally 
    as(select (sequence by instance?)
         <list> => <list>;
         <string> => <string>;
         <vector> => <vector>;
       end select, result)
  end for
end method rev;

//let (foo, bar) = values(#(foo:, bar:, baz:), #(boo:, far:, faz:));
//for (foo in "foooo")
//  format-out("%=\n", foo)
//end for;

format-out("%=\n", #(foo:, bar:, baz:).rev);
format-out("%=\n", #[foo:, bar:, baz:].rev);
format-out("%=\n", "foobarbaz".rev);

#(#"baz", #"bar", #"foo")
#[#"baz", #"bar", #"foo"]
"zabraboof"



//format-out("%=\n", concatenate(foo, bar.head.list));







