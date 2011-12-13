module: p2-9
synopsis: 
author: 
copyright: 

// 問題 2.9
// lat を要素とするリスト lats を引数とし，その要素である各 lat の先頭の要素を集めたリストを返す関数 collect-firsts を定義せよ．

define generic collect-firsts
    (lats)
 => (firsts);

define method collect-firsts
    (lats :: <list>)
 => (result :: <list>)
  case
    lats.empty? 
      => #();
    otherwise
      => pair(lats.head.head,
              lats.tail.collect-firsts)
  end;
end;


define function main(name, arguments)
  format-out("問題 2.9\n");
  format-out("lat を要素とするリスト lats を引数とし，その要素である各 lat の先頭の要素を集めたリストを返す関数 collect-firsts を定義せよ.\n");
  let x = #(#(1, 2, 3,4), #(1, 2, 3,4), #(1, 2, 3,4));
  format-out("%=.collect-firsts => %=\n",
             x,
             x.collect-firsts);
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
