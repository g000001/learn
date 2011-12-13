module: p2-8b
synopsis: 
author: 
copyright: 

// 問題 2.8
// item と lat を引数とし，
// リスト lat の中で最も左にある item を取り除く関数 rember を定義せよ．

// eval> (rember 'apple '(saw hammer apple wrench)

define generic rember
    (item, lat)
 => (lat);

define method rember
    (item, lat :: <list>)
 => (result :: <list>)
  case
    lat.empty?
      => #();
    lat.head = item
      => lat.tail;
    otherwise
      => pair(lat.head,
              rember(item, lat.tail));
  end case;
end method rember;


define function main(name, arguments)
  format-out("問題 2.8b\n");
  format-out("item と lat を引数とし，リスト lat の中で最も左にある item を取り除く関数 rember を定義せよ．\n");
  let x = #(saw:, hammer:, apple:, wrench:, apple:, grape:);
  format-out("rember(apple:, %=) => %=\n",
             x,
             rember(apple:, x));

  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
