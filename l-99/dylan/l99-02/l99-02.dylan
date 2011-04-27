module: l99-02

define generic last2
    (sequence :: <sequence>) 
 => (result :: <sequence>);

define method last2
    (sequence :: <list>)
 =>(result :: <list>)
  if (2 >= size(sequence))
    sequence
  else
    last2(tail(sequence))
  end if
end method last2;

let list = #(foo:, bar:, baz:);
format-out("%=\n", last2(list));
// => #(#"bar", #"baz")

let list = #();
format-out("%=\n", last2(list));
// => #()

let list = #(1, 2, 3, 4, 5);
format-out("%=\n", last2(list));
// => #()




