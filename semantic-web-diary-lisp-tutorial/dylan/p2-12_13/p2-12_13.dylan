module: p2-12_13
synopsis: 
author: 
copyright: 

// 問題 2.13
// リストを引数とし，その中のアトムの数を数える count-atoms を定義せよ．

define generic count-atoms
    (seq)
 => (seq);

define method count-atoms
    (lst :: <list>)
 => (result :: <integer>)
  case
    lst.empty?
      => 0;
    instance?(lst.head, <list>)
      => lst.head.count-atoms + lst.tail.count-atoms;
    otherwise
      => 1 + lst.tail.count-atoms;
  end case;
end;

define function main(name, arguments)
  format-out("問題 2.13\n");
  format-out("リストを引数とし，その中のアトムの数を数える count-atoms を定義せよ．\n");
  do(method(x) 
         format-out("%=.count-atoms => %=\n"
                      ,x
                      ,x.count-atoms)     
     end,
     #(#(1, 2, 3, 4, 5),
       #(1, 2, #(30, 31, 32), 4, 5),
       #()));
  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());
