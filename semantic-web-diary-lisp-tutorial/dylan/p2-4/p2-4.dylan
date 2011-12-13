module: p2-4
synopsis: 
author: 
copyright: 

/*
問題 2.4 
lat というのは list of atom のことである．
lat の要素に一つでも数があれば t を返すような関数　is-there-num を定義せよ．

eval> (is-there-num '(a b five c))
nil
eval> (is-there-num '(a b 5 c))
(5 c)
*/

define generic is-there-num
    (lat)
 => (result);

define method is-there-num
    (lat :: <list>)
 => (result)
  case 
    lat.empty?
      => #f;
    instance?(lat.head, <number>)
      => lat;
    otherwise
      => lat.tail.is-there-num;
  end case;
end method is-there-num;


define function main(name, arguments)
  let a = #(a:, b:, five:, c:);
  let b = #(a:, b:, 5, c:);
  format-out("a: %= => %=\n", a, a.is-there-num);
  format-out("b: %= => %=\n", b, b.is-there-num);
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
