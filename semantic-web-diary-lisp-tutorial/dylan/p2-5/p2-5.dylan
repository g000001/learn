module: p2-5
synopsis: 
author: 
copyright: 


/*
問題 2.5	
リストを引数としてその要素すべてがアトムなら t を
さもなければ nil を返す関数 is-lat を定義せよ．
*/

define generic is-lat
    (lat)
 => (result);

define method is-lat
    (lat :: <list>)
 => (result :: <boolean>)
  case 
    lat.empty?
      => #t;
    instance?(lat.head, <list>)
      => #f;
    otherwise
      => lat.tail.is-lat;
  end case;
end method is-lat;


define function main(name, arguments)
  let a = #(a:, b:, five:, c:);
  let b = #(a:, b:, #(1, 2, 3, 4), c:);
  format-out("問題 2.5\nリストを引数としてその要素すべてがアトムなら t を さもなければ nil を返す関数 is-lat を定義せよ．\n");
  format-out("%=.is-lat => %=\n", a, a.is-lat);
  format-out("%=.is-lat => %=\n", b, b.is-lat);
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
