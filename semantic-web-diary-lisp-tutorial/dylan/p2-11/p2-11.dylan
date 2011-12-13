module: p2-11
synopsis: 
author: 
copyright: 

// 問題 2.11
// key と item と lat を引数とし，
// リスト lat の中の key の左側に item を挿入する insert-left を定義せよ．

define generic insert-left
    (key, item, lat)
 => (lat);

define method insert-left
    (key, item, lat :: <list>)
 => (result :: <list>)
  case
    lat.empty? 
      => #();
    lat.head = key
      => pair(item,
              pair(lat.head,
                   insert-left(key, item, lat.tail)));
    otherwise
      => pair(lat.head, insert-left(key, item, lat.tail));
  end;
end;


define function main(name, arguments)
  format-out("問題 2.11\n");
  format-out("key と item と lat を引数とし，リスト lat の中の key の左側に item を挿入する insert-left を定義せよ\n");
  let x = #(10, 20, 30);
  format-out("insert-left(20, 15, %=) => %=\n",
             x,
             insert-left(20, 15, x));
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
