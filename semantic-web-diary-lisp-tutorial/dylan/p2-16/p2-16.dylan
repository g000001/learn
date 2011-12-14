module: p2-16
synopsis: 
author: 
copyright: 

// 問題 2.16
// リストを引数とし，その中のアトムだけを取り出してならべたリストを返す関数 squash を定義せよ．

define generic squash(seq) => (seq);

define method squash
    (lst :: <list>)
 => (result :: <list>)
  case
    lst.empty?
      => #();
    instance?(lst.head, <list>)
      => concatenate(lst.head.squash,
                     lst.tail.squash);
    otherwise
      => pair(lst.head,
              lst.tail.squash);
  end case;
end method squash;

define function main(name, arguments)
  format-out("問題 2.16\n");
  format-out("リストを引数とし，その中のアトムだけを取り出してならべたリストを返す関数 squash を定義せよ．\n");
  do(method(x) 
         format-out("%=.squash => %=\n"
                      ,x
                      ,x.squash)     
     end,
     #(#(1, 2, 3, 4, 5, not:),
       #(1, 2, #(30, 31, 32), 4, 5),
       #(),
       #(#(#(0, 0, 0, not:)), 1, 2, #(not:, 31, 32), 4, 5)));
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());