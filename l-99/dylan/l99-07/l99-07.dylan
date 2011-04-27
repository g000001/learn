module: l99-07

/*
P07 (**) Flatten a nested list structure.
    Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).

    Example:
    * (my-flatten '(a (b (c d) e)))
    (A B C D E)
*/

define generic flatten
    (sequence :: <sequence>)
 => (result :: <sequence>);

define method flatten
    (sequence :: <list>)
 => (result :: <list>)
  case
    sequence.empty? 
      => sequence;
    instance?(sequence.head, <list>)
      => concatenate(sequence.head.flatten,
                     sequence.tail.flatten);
    otherwise
      => pair(sequence.head,
              sequence.tail.flatten);
  end
end method flatten;

let seq = #(1, #(2, 3, #(4, 5, #(#(#(6, 7)),8))), 9);
format-out("%= => %=\n",seq, seq.flatten);

//#(1, #(2, 3, #(4, 5, #(#(#(6, 7)), 8))), 9) => #(1, 2, 3, 4, 5, 6, 7, 8, 9)


let seq2 = #(1, #(2, 3));
format-out("%= => %=\n",seq2, seq2.flatten);

format-out("%=\n",instance?(#(), <list>));
format-out("%=\n",concatenate(#(), #(1, 2, 3)));

/*
define function main(name, arguments)
  format-out("Hello, world!\n");
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());

*/


