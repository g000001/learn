module: p4
synopsis: 
author: 
copyright: 

// 問題 4.1
// リストを引数とし，その中の数アトムの数を返すcount-numbersをmapcarを用いて定義せよ．
define generic count-numbers
    (lst)
 => (result);

define method count-numbers
    (lst :: <list>)
 => (result :: <number>)
  if (lst.empty?)
    0;
  else 
    reduce1(\+,
            map(method(x) 
                    select (x by instance?)
                      <list> => x.count-numbers;
                      <number> => 1;
                      otherwise
                        => 0;
                    end;
                end,
                lst));
    // reduce(method(ans, x) 
    //            select (x by instance?)
    //              <list> => ans + x.count-numbers;
    //              <number> => ans + 1;
    //              otherwise
    //                => ans;
    //            end;
    //        end method,
    //        0,
    //        lst);
  end if;
end method count-numbers;

// 問題 4.2
// リストを引数とし，その中のシンボル not をすべて取り除く関数
// delete-not をmapcanを用いて定義せよ．（要素がnotだったら，それを除きた
// いのだけれど，そういうコードは難しい．とりあえずnil を与えておいて返っ
// てきたものを append するとnilはつぶれる．けれどもnot以外のところはつぶ
// れては困るから・・・）
define generic delete-not
    (seq)
 => (seq);

define method delete-not
    (lst :: <list>)
 => (result :: <list>)
  reduce(method(ans, x)
             select (x)
               not: => ans;
               otherwise
                 => let elt = select(x by instance?)
                                <list> => x.delete-not;
                                otherwise => x;
                              end select;
                 concatenate!(ans, elt.list);
             end select;
         end method,
         #(),
         lst);
end method delete-not;

// 問題 4.3
// リストを引数とし，その中のアトムだけを取り出してならべたリストを返す
// 関数 squash をmapcanを用いて定義せよ．ちなみに問題2.16の答えは次のとお
// り(Winston の Lisp，第３版問題5-9)．今度はmapcanを使う．
define generic squash
    (lst)
 => (ans);

define method squash
    (lst :: <list>)
 => (result :: <list>)
  reduce(method(ans, e)
             let f = select(e by instance?)
                       <list> => squash;
                       otherwise => list;
                     end select;
             concatenate!(ans, f(e));
         end method,
         #(),
         lst)
end method squash;

// main
define function main(name, arguments)
  format-out("問題 4.1\n");
  format-out("リストを引数とし，その中の数アトムの数を返す count-numbersをmapcarを用いて定義せよ．\n");

  let lst = #(a:, b:, #(#(#(0)), 1, 2, 3, 4, #(5, c:, d:)));
  format-out("%=.count-numbers => %=\n",
             lst,
             lst.count-numbers);

  format-out("問題 4.2\n");
  format-out("リストを引数とし，その中のシンボル not をすべて取り除く関数 delete-not をmapcanを用いて定義せよ．（要素がnotだったら，それを除きたいのだけれど，そういうコードは難しい．とりあえずnil を与えておいて返ってきたものを append するとnilはつぶれる．けれどもnot以外のところはつぶれては困るから・・・）\n");

  let lst = #(not:, not:, #(#(#(0)), 1, 2, 3, 4, #(5, not:, not:)));
  format-out("%=.delete-not => %=\n",
             lst,
             lst.delete-not);

  format-out("問題 4.3\n");
  format-out("リストを引数とし，その中のアトムだけを取り出してならべたリストを返す関数 squash をmapcanを用いて定義せよ．ちなみに問題2.16の答えは次のとおり(Winston の Lisp，第３版問題5-9)．今度はmapcanを使う．\n");

  let lst = #(not:, not:, #(#(#(0)), 1, 2, 3, 4, #(5, not:, not:)));
  format-out("%=.squash => %=\n",
             lst,
             lst.squash);

  let lst = #();
  format-out("%=.squash => %=\n",
             lst,
             lst.squash);

  exit-application(0);
end function main;

// Invoke our main() function.
main(application-name(), application-arguments());