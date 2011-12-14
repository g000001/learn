module: p2-15
synopsis: 
author: 
copyright: 

// 問題 2.15
// リストを引数とし，その中のシンボル not をすべて取り除く関数 delete-not を定義せよ．

define generic delete-not(seq) => (seq);

define method delete-not
    (lst :: <list>)
 => (result :: <list>)
  case
    lst.empty?
      => #();
    instance?(lst.head, <list>)
      => pair(lst.head.delete-not,
              lst.tail.delete-not);
    lst.head = not:
      => lst.tail.delete-not;
    otherwise
      => pair(lst.head,
              lst.tail.delete-not);
  end case;
end method delete-not;

define function main(name, arguments)
  format-out("問題 2.15\n");
  format-out("リストを引数とし，その中のシンボル not をすべて取り除く関数 delete-not を定義せよ．\n");
  do(method(x) 
         format-out("%=.delete-not => %=\n"
                      ,x
                      ,x.delete-not)     
     end,
     #(#(1, 2, 3, 4, 5, not:),
       #(1, 2, #(30, 31, 32), 4, 5),
       #(),
       #(#(#(0, 0, 0, not:)), 1, 2, #(not:, 31, 32), 4, 5)));
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
