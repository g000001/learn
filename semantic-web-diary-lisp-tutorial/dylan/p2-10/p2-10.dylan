module: p2-10
synopsis: 
author: 
copyright: 

// 問題 2.10
// key と item と lat を引数とし，
// リスト lat の中の key の右側に item を挿入する insert-right を定義せよ．
// eval> (insert-right 'is 'very '(intelligent agent is nice))
// (intelligent agent is very nice)

define generic insert-right
    (key, item, lat)
 => (lat);

define method insert-right
    (key, item, lat :: <list>)
 => (result :: <list>)
  case
    lat.empty? 
      => #();
    lat.head = key
      => pair(lat.head,
              pair(item,
                   insert-right(key, item, lat.tail)));
      // => concatenate(list(lat.head),
      //                list(item),
      //                insert-right(key, item, lat.tail));
    otherwise
      => pair(lat.head, insert-right(key, item, lat.tail));
  end;
end;


define function main(name, arguments)
  format-out("問題 2.10\n");
  format-out("key と item と lat を引数とし，リスト lat の中の key の右側に item を挿入する insert-right を定義せよ\n");
  let x = #(intelligent:, agent:, is:, nice:);
  format-out("insert-right(is:, very:, %=) => %=\n",
             x,
             insert-right(is:, very:, x));
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
