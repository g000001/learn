module: p2-7
synopsis: 
author: 
copyright: 

// 問題 2.7
// リストを引数とし，その要素のうち数であるものの数を返す関数 count-num を定義せよ

define generic count-num
    (lat)
 => (result);

define method count-num
    (lat :: <list>)
 => (result :: <number>)
  case
    lat.empty? 
      => 0;
    instance?(lat.head, <number>) 
      => 1 + lat.tail.count-num;
    otherwise
      => lat.tail.count-num;
  end case;
end method count-num;

define function main(name, arguments)
  format-out("問題 2.7\n");
  format-out("リストを引数とし，その要素のうち数であるものの数を返す関数 count-num を定義せよ\n");
  let x = #(1, 2, 3, 4);
  let y = #(1, 2, 3, 4, five:, 10);
  let z = #();
  format-out("%=.count-num => %=\n", x, x.count-num);
  format-out("%=.count-num => %=\n", y, y.count-num);
  format-out("%=.count-num => %=\n", z, z.count-num);
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
