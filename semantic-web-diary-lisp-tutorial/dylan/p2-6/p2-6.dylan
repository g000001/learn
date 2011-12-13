module: p2-6
synopsis: 
author: 
copyright: 

// 問題 2.6
// lnum というのは　list of number のことである．
// リストを引数としてその要素すべてが数字なら t をさもなければ nil を返す関数 is-lnum を定義せよ．

define generic is-lnum
    (lat)
 => (result);

define method is-lnum
    (lat :: <list>)
 => (result :: <boolean>)
  case
    lat.empty? => #t;
    ~instance?(lat.head, <number>) => #f;
    otherwise => lat.tail.is-lnum;
  end case;
end method is-lnum;

define function main(name, arguments)
  format-out("問題 2.6\n");
  format-out("lnum というのは　list of number のことである．\n");
  format-out("リストを引数としてその要素すべてが数字なら t をさもなければ nil を返す関数 is-lnum を定義せよ．\n");
  let x = #(1, 2, 3, 4);
  let y = #(1, 2, 3, 4, five:);
  format-out("%=.is-lnum => %=\n", x, x.is-lnum);
  format-out("%=.is-lnum => %=\n", y, y.is-lnum);
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
