module: l99-03

// P03 (*) Find the K'th element of a list.
//    The first element in the list is number 1.
//    Example:
//    * (element-at '(a b c d e) 3)
//    C

define generic element-at 
    (sequence :: <sequence>, position :: <integer>)
 => (result :: false-or(<symbol>));

define method element-at 
    (sequence :: <list>, position :: <integer>)
 => (result :: false-or(<symbol>))
  case 
    empty?(sequence) => #f;
    1 >= position => head(sequence);
    otherwise => element-at(tail(sequence), position - 1);
  end case
end method element-at;

/*
define method element-at 
    (sequence :: <list>, position :: <integer>)
 => (result :: false-or(<symbol>))
  for (i = 1 then i + 1,
       until: i == position)

  case 
    empty?(sequence) => #f;
    1 >= position => head(sequence);
    otherwise => element-at(tail(sequence), position - 1);
  end case;
end method element-at;
*/

// define function element-at (sequence, number)
//   if (empty? list)
//     #f
//   else 
//     if (1 >= number)
//       head(list)
//     else
//       element-at(tail(list), number - 1)
//     end if;
//   end if;
// end function element-at;

// define function element-at (sequence, number)
//   case 
//     empty?(sequence) => #f;
//     1 >= number => head(sequence);
//     otherwise => element-at(tail(sequence), number - 1);
//   end case;
// end function element-at;

format-out("%=\n", element-at(#(a:, b:, c:, d:, e:), 3));
format-out("%=\n", element-at(#(), 3));
format-out("%=\n", element-at(#(foo:, bar:), 3));
format-out("%=\n", element-at(#(foo:, bar:, baz:, quux:), 3));
