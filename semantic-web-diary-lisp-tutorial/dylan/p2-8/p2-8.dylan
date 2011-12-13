module: p2-8
synopsis: 
author: 
copyright: 

// 問題 2.8
// リストを引数とし，その要素のうちアトムであるものの数を返す関数 count-atom を定義せよ．

define generic count-atom
    (lat)
 => (result);

define method count-atom
    (lat :: <list>)
 => (result :: <number>)
  case
    lat.empty? 
      => 0;
    ~instance?(lat.head, <list>) 
      => 1 + lat.tail.count-atom;
    otherwise
      => lat.tail.count-atom;
  end case;
end method count-atom;

define function main(name, arguments)
  format-out("問題 2.8\n");
  format-out("リストを引数とし，その要素のうちアトムであるものの数を返す関数 count-atom を定義せよ．\n");
  let x = #(1, 2, 3, 4);
  let y = #(1, 2, 3, 4, #(list:, list:, list:), 10);
  let z = #();
  format-out("%=.count-atom => %=\n", x, x.count-atom);
  format-out("%=.count-atom => %=\n", y, y.count-atom);
  format-out("%=.count-atom => %=\n", z, z.count-atom);
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
