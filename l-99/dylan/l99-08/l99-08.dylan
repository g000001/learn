module: l99-08

/*
P08 (**) Eliminate consecutive duplicates of list elements.
    If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.

    Example:
    * (compress '(a a a a b c c a a d e e e e))
    (A B C A D E)
*/

define generic compress 
    (sequence :: <sequence>)
 => (result :: <sequence>);

define method compress 
    (sequence :: <sequence>)
 => (result :: <sequence>)
  let result = make(<deque>);
  for (elt in sequence)
    if (result.empty? | elt ~= result.last)
      push-last(result, elt)
    end if
  finally
    as(select (sequence by instance?)
         <list> => <list>;
         <string> => <string>;
         <vector> => <vector>;
       end select, result)
  end for
end method compress;

format-out("%=\n", #(a:, a:, a:, a:, b:, c:, a:, a:, d:, e:, e:, e:, e:).compress);
format-out("%=\n", #[a:, a:, a:, a:, b:, c:, a:, a:, d:, e:, e:, e:, e:].compress);
format-out("%=\n", "aaaabcaadeeee".compress);


//let foo = make(<deque>);
//push(foo, x:);
//format-out("%=\n", foo[0]);
