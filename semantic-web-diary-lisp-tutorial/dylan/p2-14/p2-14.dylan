module: p2-14
synopsis: 
author: 
copyright: 

// 問題 2.14
// リストを引数とし，その中のアトムがすべて数なら t を返すall-numberp を定義せよ．

define generic all-numberp
    (seq)
 => (seq);

define method all-numberp
    (lst :: <list>)
 => (result :: <boolean>)
  case
    lst.empty?
      => #t;
    instance?(lst.head, <list>)
      => lst.head.all-numberp & lst.tail.all-numberp;
    otherwise
      => instance?(lst.head, <number>) & lst.tail.all-numberp;
  end case;
end method;

define function main(name, arguments)
  format-out("問題 2.14\n");
  format-out("リストを引数とし，その中のアトムがすべて数なら t を返すall-numberp を定義せよ．\n");
  do(method(x) 
         format-out("%=.all-numberp => %=\n"
                      ,x
                      ,x.all-numberp)     
     end,
     #(#(1, 2, 3, 4, 5),
       #(1, 2, #(30, 31, 32), 4, 5),
       #(),
       #(#(#(0, 0, 0, number:)), 1, 2, #(30, 31, 32), 4, 5)));
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());