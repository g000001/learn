%P01  (*) Find the last element of a list.
%    Example:
%    ?- my_last(X,[a,b,c,d]).
%    X = d
%

my_last([],X) :- false.
my_last([X], X).
my_last([H|T], X) :- my_last(T, X).

% P2
%last_but_one_element([], _) :- false.
%last_but_one_element([X], X) :- false.
last_but_one_element([X,_], X).
last_but_one_element([_|T], X) :- last_but_one_element(T, X).

%% P03 (*) Find the K'th element of a list.
%%     The first element in the list is number 1.
%%     Example:
%%     ?- element_at(X,[a,b,c,d,e],3).
%%     X = c

element_at(X, [H|_], 1) :- X = H.
%-> element_at(X, [X|_], 1).
%と書ける
element_at(X, [H|T], K) :- K1 is K - 1, element_at(X, T, K1).
% N > 1が必要らしい。なくても動くよ


%% P04 (*) Find the number of elements of a list.

number_of_elements(0, []).
number_of_elements(X, [H|T]) :- number_of_elements(X1, T), X is X1 + 1.


%%P5
%REVERSE-A-LIST

my_reverse([],[]).
my_reverse([H|T],R) :- my_reverse(T, R1), append(R1, [H], R).

%P6 is_palindrome
%is_palindrome(X) :- reverse(X,Y), X = Y.
is_palindrome(X) :- my_reverse(X, X).


%P7 my-flatten

my_flatten([],[]).
my_flatten([H|T],Ans) :- is_list(H), my_flatten(T, T1), append(H, T1, Ans).
my_flatten([H|T],[H|T1]) :- my_flatten(T, T1).


% p8 (defun compress (list)

compress([X], [X]).
compress([X,X|T], Ans) :- compress([X|T], Ans).
compress([X,Y|T], [X|Ans]) :- compress([Y|T], Ans).

% p9 (DEFUN PACK (LIST &OPTIONAL (FUNC #'EQ))

pack([X],[[X]]).
pack([X,X|T], Ans) :- pack([T], Ans)
pack()

pack1([X,X|T], [X|T], Acc) :- pack1([X|T]])

transfer(X,[],[],[X]).
transfer(X,[Y|Ys],[Y|Ys],[X]) :- X \= Y.
transfer(X,[X|Xs],Ys,[X|Zs]) :- transfer(X,Xs,Ys,Zs).

pack([],[]).
pack([X|Xs],[Z|Zs]) :- transfer(X,Xs,Ys,Z), pack(Ys,Zs).


% p10 (defun encode (list)

encode([], []).
encode([X|Xs],[[L,X]|Zs]) :- transfer(X,Xs,Ys,Z), length(Z,L), encode(Ys,Zs).


%% P11  (*) Modified run-length encoding.
%%     Modify the result of problem P10 in such a way that if an element has
%%     no duplicates it is simply copied into the result list. Only elements with
%%     duplicates are transferred as [N,E] terms.
%%     Example:
%%     ?- encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
%%     X = [[4,a],b,[2,c],[2,a],d,[4,e]]

encode_modified([], []).
encode_modified([X|Xs],[X|Zs]) :-
	transfer(X,Xs,Ys,Z),
	length(Z,1),
	encode_modified(Ys,Zs).
encode_modified([X|Xs],[[L,X]|Zs]) :-
	transfer(X,Xs,Ys,Z),
	length(Z,L),
	L \= 1,
	encode_modified(Ys,Zs).


%% P12  (**) Decode a run-length encoded list.
%%     Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.

%defrate(N,Item, Ans)
defrate(1,Item, [Item]) :- !.
defrate(N,Item, [Item|Rest]) :- N1 is N - 1, defrate(N1, Item, Rest).

decode([], []).
decode([[Len, Item]|T], Res) :-
	defrate(Len, Item, A),
	decode(T, Ans),
	append(A,Ans,Res).
decode([Item|T], Res) :-
	not(is_list(Item)),
	decode(T, Ans),
	append([Item],Ans,Res).


%% P13  (**) Run-length encoding of a list (direct solution).
%%     Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them. As in problem P11, simplify the result list by replacing the singleton terms [1,X] by X.

%%     Example:
%%     ?- encode_direct([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
%%     X = [[4,a],b,[2,c],[2,a],d,[4,e]]


transfer2(X, [], [], X).
transfer2(X, [Y|Ys], [Y|Ys], [X]) :- X \= Y.
transfer(X, [X|Xs], Ys, [X|Zs]) :- transfer(X, Xs, Ys, Zs).

len_and_item(New, [Len, Item], [Len1, Item]) :-
        New = Item,
        Len1 is Len + 1.
len_and_item(New, Item, [2, Item]) :-
        New = Item.

encode_direct([], []).
encode_direct([X|Xs], [Z|Zs]) :-
        transfer(X, Xs, Ys, Z),
        encode_direct(Ys, Zs).


        len_and_item(X,)

fact1(0, Acc, Acc) :- !.
fact1(N, Acc, Ans) :- N1 is N - 1, Acc1 is N * Acc, fact(N1, Acc1, Ans).

fact(X,Y) :- fact1(X,1,Y).


factorial(0,1) :- !.
factorial(N,Ans) :- N1 is N - 1, factorial(N1, Ans1), Ans is Ans1 * N.


tran(X,[],[X]).
tran(X,[Y|_],[X]) :- X \= Y.
tran(X,[Y|Xs],[X|Zs]) :- tran(X,Xs,Zs).


strip([1,X], X) :- !.
strip(X, X).

encode_direct([], []).
encode_direct([X|Xs], [A|As]) :- strip(A,A1), encode([X|Xs], [A1|As]).

%% P13  (**) Run-length encoding of a list (direct solution).
%%     Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them. As in problem P11, simplify the result list by replacing the singleton terms [1,X] by X.

%%     Example:
%%     ?- encode_direct([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
%%     X = [[4,a],b,[2,c],[2,a],d,[4,e]]


transfer2(X,[],[],A,X,Acc).
transfer2(X,[X],[X],A,X) :- transfer2(X,[],[],1,X).

transfer2(X,[Y|Ys],[Y|Ys],1,X) :- X \= Y.
transfer2(X,[X|Xs],Ys, C, X) :- transfer2(X,Xs,Ys,C1,X), C is C1 + 1.

transfer2(X,[X|Xs],Ys,[X|Zs]) :- transfer(X,Xs,Ys,Zs).

pack([],[]).
pack([X|Xs],[Z|Zs]) :- transfer(X,Xs,Ys,Z), pack(Ys,Zs).



transfer(X,[],[],[X]).
transfer(X,[Y|Ys],[Y|Ys],[X]) :- X \= Y.
transfer(X,[X|Xs],Ys,[X|Zs]) :- transfer(X,Xs,Ys,Zs).


foo(X,[],[],1,X).
foo(X,[],[],N,X) :- N > 1.
foo(X,[Y|Ys],[Y|Ys],1,X) :- X \= Y.
foo(X,[Y|Ys],[Y|Ys],N, X) :- X \= Y, N > 1.
foo(X,[X|Xs],Ys,N,X) :- N is N1 + 1, foo(X,Xs,Ys,N1,X).

%% foo(a,[a,a,b,c,d,e],Z,N,X).
%% Z = [b, c, d, e],
%% N = 3,
%% X = a


encode_direct([], []).
encode_direct([X|Xs],[X|As]) :-
        foo(X,Xs,As,1,X),
        encode_direct(Xs,As)

encode_direct([X|Xs],[[N,X]|As]) :-
        foo(X,Xs,As,N,X),
        encode_direct(Xs,As).



foo(X,[],[],1,X).
foo(X,[],[],N,[N,X]) :- N > 1.
foo(X,[Y|Ys],[Y|Ys],1,X) :- X \= Y.
foo(X,[Y|Ys],[Y|Ys],N, [N,X]) :- X \= Y, N > 1.
foo(X,[X|Xs],Ys,N,T) :- N1 is N + 1, foo(X,Xs,Ys,N1,T).

%% foo(a,[a,a,b,c,d,e],Z,N,X).
%% Z = [b, c, d, e],
%% N = 3,
%% X = a


encode_direct([], []).
encode_direct([X|Xs],[X|Zs]) :-
        foo(X,Xs,As,1,X),
        encode_direct(As,Zs).
encode_direct([X|Xs],[[N,X]|Zs]) :-
        foo(X,Xs,As,N,X),
        encode_direct(As,Zs).


count(X,[],[],1,X).
count(X,[],[],N,[N,X]) :- N > 1.
count(X,[Y|Ys],[Y|Ys],1,X) :- X \= Y.
count(X,[Y|Ys],[Y|Ys],N,[N,X]) :- N > 1, X \= Y.
count(X,[X|Xs],Ys,K,T) :- K1 is K + 1, count(X,Xs,Ys,K1,T).

encode_direct([],[]).
encode_direct([X|Xs],[Z|Zs]) :- count(X,Xs,Ys,1,Z), encode_direct(Ys,Zs).


%% P14  (*) Duplicate the elements of a list.
%%     Example:
%%     ?- dupli([a,b,c,c,d],X).
%%     X = [a,a,b,b,c,c,c,c,d,d]

dupli([H], [H,H]).
dupli([H|T], [H,H|T2]) :- dupli(T, T2).


%% P15  (**) Duplicate the elements of a list a given number of times.
%%     Example:
%%     ?- dupli([a,b,c],3,X).
%%     X = [a,a,a,b,b,b,c,c,c]

%%     What are the results of the goal:
%%     ?- dupli(X,3,Y).

expand(Item,0,[]).
expand(Item,N,[Item|Tail]) :- N > 0, N1 is N - 1, expand(Item, N1, Tail).

repli([], _, []).
repli([_], 0, []).
repli([H|T], N, Ans) :- expand(H, N, X) ,repli(T, N, Ans2), append(X, Ans2, Ans).

%
% X = [],
% Y = [] ;
% X = [_G267],
% Y = [_G267, _G267, _G267] ;
% X = [_G267, _G279],
% Y = [_G267, _G267, _G267, _G279, _G279, _G279] .
%

%% P16  (**) Drop every N'th element from a list.
%%     Example:
%%     ?- drop([a,b,c,d,e,f,g,h,i,k],3,X).
%%     X = [a,b,d,e,g,h,k]

% drop([_], 1, []).
% drop([H|])
%
% drop1([_], 1, _, []).
% drop1([H|T], M, N, Acc) :- Z is N mod M, Z = 0, !, N1 is N + 1, drop1(T, M, N1, Acc).
% drop1([H|T], M, N, [h|Acc]) :- N1 is N + 1, print([H]),drop1(T, M, N1, Acc).
%
%
%
% copyl([], []).
% copyl([H|T],[h|As]) :- copyl(T,As).
%
%
% drop1([], _, _, []).
% drop1([H|T], M, N, Acc) :- Z is N mod M, Z = 0, !, N1 is N + 1, drop1(T, M, N1, Acc).
% drop1([H|T], M, N, [H|Acc]) :- N1 is N + 1, print([H]),drop1(T, M, N1, Acc).
%
%
drop1([], _, _, []).
drop1([H|T], M, N, Acc) :-
        Z is N mod M,
        Z = 0, !,
        N1 is N + 1,
        drop1(T, M, N1, Acc).
drop1([H|T], M, N, [H|Acc]) :-
        N1 is N + 1,
        drop1(T, M, N1, Acc).

drop(X, N, A) :- drop1(X, N, 1, A).

drop([a,b,c,d,e,f,g,h,i,k], 3, [a,b,d,e,g,h,k]).
%=> true

%%     X = [a,b,d,e,g,h,k]


%% P17  (*) Split a list into two parts; the length of the first part is given.
%%     Do not use any predefined predicates.

%%     Example:
%%     ?- split([a,b,c,d,e,f,g,h,i,k],3,L1,L2).
%%     L1 = [a,b,c]
%%     L2 = [d,e,f,g,h,i,k]

split([],_,[],[]).
split(X,N,L1,L2) :- append(L1,L2,X), length(L1,N).


%% P18  (**) Extract a slice from a list.
%%     Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the original list (both limits included). Start counting the elements with 1.

%%     Example:
%%     ?- slice([a,b,c,d,e,f,g,h,i,k],3,7,L).
%%     X = [c,d,e,f,g]

slice([],_,_,[]).
slice(X,S,E,A) :-
        S1 is S - 1,
        split(X,S1,_,A1),
        E1 is E - S1,
        split(A1, E1, A, _).


%% P19  (**) Rotate a list N places to the left.
%%     Examples:
%%     ?- rotate([a,b,c,d,e,f,g,h],3,X).
%%     X = [d,e,f,g,h,a,b,c]

%%     ?- rotate([a,b,c,d,e,f,g,h],-2,X).
%%     X = [g,h,a,b,c,d,e,f]

%%     Hint: Use the predefined predicates length/2 and append/3, as well as the result of problem P17.

rotate([], _, []).
rotate(X, 0, X).
rotate(X, N, Ans) :-
        N > 0,
        split(X, N, L1, L2),
        append(L2, L1, Ans).
rotate(X, N, Ans) :-
        N < 0,
        length(X, N1),
        N2 is N1 + N,
        split(X, N2, L1, L2),
        append(L2, L1, Ans).

% rotate([a,b,c,d,e,f,g,h], 3, [d,e,f,g,h,a,b,c]).
% rotate([a,b,c,d,e,f,g,h], -2, [g,h,a,b,c,d,e,f]).
%

%% P20  (*) Remove the K'th element from a list.
%%     Example:
%%     ?- remove_at(X,[a,b,c,d],2,R).
%%     X = b
%%     R = [a,c,d]

remove_at(X, L, K, R) :-
        K1 is K - 1,
        split(L, K1, L1, [X|L2]), !,
        append(L1, L2, R).

remove_at(b,[a,b,c,d],2,[c,d,e]).

%% P21  (*) Insert an element at a given position into a list.
%%     Example:
%%     ?- insert_at(alfa,[a,b,c,d],2,L).
%%     L = [a,alfa,b,c,d]

insert_at(Item, List, N, Ans) :- remove_at(Item, Ans, N, List).

% 太郎(男).


%% P22  (*) Create a list containing all integers within a given range.
%%     Example:
%%     ?- range(4,9,L).
%%     L = [4,5,6,7,8,9]

range(X,X,[X]) :- !.
range(S,E,[S|Rest]) :- S1 is S + 1, range(S1,E,Rest).
%
%
% range(4,9,[4, 5, 6, 7, 8, 9]).
%
% range(4,X,[4, 5, 6, 7, 8, 9]).
% range(Y,X,[4, 5, 6, 7, 8, 9]).
%

%% P23  (**) Extract a given number of randomly selected elements from a list.
%%     The selected items shall be put into a result list.
%%     Example:
%%     ?- rnd_select([a,b,c,d,e,f,g,h],3,L).
%%     L = [e,d,a]

%%     Hint: Use the built-in random number generator random/2 and the result of problem P20.
rnd_select(_, 0, []) :- !.
rnd_select(List, N, [Item|Ans]) :-
        length(List, Len),
        Pos is random(Len) + 1,
        remove_at(Item, List, Pos, Rest),
        N1 is N - 1,
        rnd_select(Rest, N1, Ans).

%%     ?- remove_at(X,[a,b,c,d],2,R).
%%     X = b
%%     R = [a,c,d]
%
%
%
% ulam(1,1).
% ulam(2,2).
% ulam(N,Ans) :-
%
%
%
% findall([X,Y],choice_and_sum(5,X,Y,[1,2,3,4,5,6,7]),L).
%
% choice_and_sum(N,X,Y,List) :-
%         member(X, List),member(Y, List),
%         X < Y,
%         N is X + Y.
%
% choice_and_sum() :- false.
%
%
%% P24  (*) Lotto: Draw N different random numbers from the set 1..M.
%%     The selected numbers shall be put into a result list.
%%     Example:
%%     ?- rnd_select(6,49,L).
%%     L = [23,1,17,33,21,37]

lotto(N, Size, Ans) :- range(1, Size, X), rnd_select(X, N, Ans).

%% P25  (*) Generate a random permutation of the elements of a list.
%%     Example:
%%     ?- rnd_permu([a,b,c,d,e,f],L).
%%     L = [b,a,d,c,e,f]

%%     Hint: Use the solution of problem P23.

% rnd_permu([],[]) :- !.
rnd_permu(L, Ans) :- length(L, Len), rnd_select(L, Len, Ans).


%% P26  (**) Generate the combinations of K distinct objects chosen from the N elements of a list
%%     In how many ways can a committee of 3 be chosen from a group of 12 people? We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients). For pure mathematicians, this result may be great. But we want to really generate all the possibilities (via backtracking).

%%     Example:
%%     ?- combination(3,[a,b,c,d,e,f],L).
%%     L = [a,b,c] ;
%%     L = [a,b,d] ;
%%     L = [a,b,e] ;
%%     ...


item_rest(X,[],[X]).
item_rest(X, [H|T], [X|L]) :- item_rest(H,T,L).

?- item_rest(X,[1,2,3,4],Y).
Y = [X, 1, 2, 3, 4] ;

ap([],L,L).
ap([L1|Ls1], L2, [L1|As]) :- ap(Ls1, L2, As).

combination(_, [], []).
combination(1, [H|T], [H]) :- combination(1, [H|T], [H])


comb(1,L,[X]) :- member(X,L).

comb(2,[L|Ls],Ans) :-
        member(X,[L|Ls]),
        member(Y,Ls),
        append([X],[Y],Ans).
comb(3,[L|Ls],Ans) :-
        member(X,[L|Ls]),
        comb(2,Ls,Ys),
        append([X],Ys,Ans).





comb(2,[L|Ls],Ans) :-
        comb(1, [L|Ls], X),
        comb(1, Ls, Y),
        append(X,Y,Ans).
comb(N,[L|Ls],Ans) :-
        N > 2,
        member(X, [L|Ls]),
        N1 is N - 1,
        comb(N1, Ls, Y),
        append([X],Y,Ans).

comb(N,[L|Ls],[L|As]) :-
        member(X, [L|Ls]),
        N1 is N - 1,
        comb(N1, Ls, B),
        append([X], B, As).



el(X,[X|L],L).
el(X,[_|L],R) :- el(X,L,R).

combination(0,_,[]).
combination(N,Ls,Ans) :-
        N > 0,
        el(A, Ls, T),
        N1 is N - 1,
        combination(N1, T, As),
        append([A], As, Ans).

combination(0,_,[]).
combination(N,Ls,[A|As]) :-
        N > 0,
        el(A, Ls, T),
        N1 is N - 1,
        combination(N1, T, As).



%% P27  (**) Group the elements of a set into disjoint subsets.
%%     a) In how many ways can a group of 9 people work in 3 disjoint subgroups of 2, 3 and 4 persons? Write a predicate that generates all the possibilities via backtracking.

%%     Example:
%%     ?- group3([aldo,beat,carla,david,evi,flip,gary,hugo,ida],G1,G2,G3).
%%     G1 = [aldo,beat], G2 = [carla,david,evi], G3 = [flip,gary,hugo,ida]
%%     ...

%%     b) Generalize the above predicate in a way that we can specify a list of group sizes and the predicate will return a list of groups.

%%     Example:
%%     ?- group([aldo,beat,carla,david,evi,flip,gary,hugo,ida],[2,2,5],Gs).
%%     Gs = [[aldo,beat],[carla,david],[evi,flip,gary,hugo,ida]]
%%     ...

%%     Note that we do not want permutations of the group members; i.e. [[aldo,beat],...] is the same solution as [[beat,aldo],...]. However, we make a difference between [[aldo,beat],[carla,david],...] and [[carla,david],[aldo,beat],...].

%%     You may find more about this combinatorial problem in a good book on discrete mathematics under the term "multinomial coefficients".

%?- group3([aldo,beat,carla,david,evi,flip,gary,hugo,ida],G1,G2,G3).
%G1 = [aldo,beat], G2 = [carla,david,evi], G3 = [flip,gary,hugo,ida]

%combination(3,[a,b,c,d,e],X)
%
%
%group3([], [], [], []).
%group3(List, )
%
%
%comb_rest(0,_,[],_).
%
%comb_rest(N, Ls, [A|As], T) :-
%        N > 0,
%        el(A, Ls, T),
%        N1 is N - 1,
%        comb_rest(N1, T, As, T).
%
%
%gen_gm(X, [X|T], T).
%gen_gm(X, [X,_|T], T) :- gen_gm(X, [X|T], T).
%
%atomic_list_concat(['は','よ','う','ご','ざ','い','ま'],X).


rnd_gm(Ans) :-
        rnd_permu(['は','よ','う','ご','ざ','い','ま'],X),
        append([['お'],X, ['す','！']], X1),
        atomic_list_concat(X1,Ans).



rnd_gm(Ans):-rnd_permu(['は','よ','う','ご','ざ','い','ま'],X),append([['お'],X,['す','！']],X1),atomic_list_concat(X1,Ans).



combination2(0,X,[],X).
combination2(N,Ls,[A|As], Ls) :-
        N > 0,
        el(A, Ls, T),
        N1 is N - 1,
        combination2(N1, T, As, T).


el2(X, [X|T], T).
el2(X, [_|R], T) :- el2(X, R, T).


foo(X,Ans) :- append(X1,X2,X), combination(2,X,)



el(X,[X|L],L).
el(X,[_|L],R) :- el(X,L,R).

selectN(0, _, []).
selectN(N, Xs, [A|As]) :-
        N > 0,
        el(A, Xs, Rest),
        N1 is N - 1,
        selectN(N1, Rest, As).


group3(X,G1,G2,G3) :-
        selectN(2, X, G1),
        subtract(X, G1, Rest1),
        selectN(3, Rest1, G2),
        subtract(Rest1, G2, Rest2),
        selectN(4, Rest2, G3).

%?- group3([aldo,beat,carla,david,evi,flip,gary,hugo,ida],G1,G2,G3).
%G1 = [aldo,beat], G2 = [carla,david,evi], G3 = [flip,gary,hugo,ida]


?- findall(_,group3([aldo,beat,carla,david,evi,flip,gary,hugo,ida],G1,G2,G3),Y),length(Y,L).
Y = [_G4232, _G4229, _G4226, _G4223, _G4220, _G4217, _G4214, _G4211, _G4208|...],
L = 1260.


%nCr=n!/r!(n-r)!
%で、n =


%% ?- group([aldo,beat,carla,david,evi,flip,gary,hugo,ida],[2,2,5],Gs).
%% Gs = [[aldo,beat],[carla,david],[evi,flip,gary,hugo,ida]]


group(_, [], []).
group(List, [P|Ps], [G|Gs]) :-
        selectN(P, List, G),
        subtract(List, G, Gs),
        group(Gs, Ps, Gs).

group([], [], []).
group(List, [P|Ps], [G|Gs]) :-
        selectN(P, List, G),
        subtract(List, G, R),
        group(R, Ps, Gs).

%% P28  (**) Sorting a list of lists according to length of sublists
%%     a) We suppose that a list (InList) contains elements that are lists themselves. The objective is to sort the elements of InList according to their length. E.g. short lists first, longer lists later, or vice versa.

%%     Example:
%%     ?- lsort([[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],L).
%%     L = [[o], [d, e], [d, e], [m, n], [a, b, c], [f, g, h], [i, j, k, l]]

%%     b) Again, we suppose that a list (InList) contains elements that are lists themselves. But this time the objective is to sort the elements of InList according to their length frequency; i.e. in the default, where sorting is done ascendingly, lists with rare lengths are placed first, others with a more frequent length come later.

%%     Example:
%%     ?- lfsort([[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],L).
%%     L = [[i, j, k, l], [o], [a, b, c], [f, g, h], [d, e], [d, e], [m, n]]

%%     Note that in the above example, the first two lists in the result L have length 4 and 1, both lengths appear just once. The third and forth list have length 3 which appears, there are two list of this length. And finally, the last three lists have length 2. This is the most frequent length.


gt(Item, [], []).
gt(Item, [L|Ls], [L|R]) :-
        L > Item,
        gt(Item, Ls, R).
gt(Item , [L|Ls], R) :-
        L =< Item,
        gt(Item ,Ls, R).

le(Item, [], []).
le(Item, [L|Ls], [L|R]) :-
        L =< Item,
        le(Item, Ls, R).
le(Item , [L|Ls], R) :-
        L > Item,
        le(Item ,Ls, R).


qsort([], []).
qsort([Piv|Ls], Ans) :-
        gt(Piv, Ls, Gt),
        le(Piv, Ls, Lt),
        qsort(Lt, Lt1),
        qsort(Gt, Gt1),
        append([Lt1, [Piv], Gt1], Ans).


lgt(Len, [], []).
lgt(Len, [L|Ls], [L|R]) :-
        length(L, LLen),
        LLen > Len,
        lgt(Len, Ls, R).
lgt(Len , [L|Ls], R) :-
        length(L, LLen),
        LLen =< Len,
        lgt(Len ,Ls, R).

lle(Len, [], []).
lle(Len, [L|Ls], [L|R]) :-
        length(L, LLen),
        LLen =< Len,
        lle(Len, Ls, R).
lle(Len , [L|Ls], R) :-
        length(L, LLen),
        LLen > Len,
        lle(Len ,Ls, R).


%lgt(2,[[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]]).

%?- lgt(2,[[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]], X).
%X = [[a, b, c], [f, g, h], [i, j, k, l]] ;
%false.

lsort([], []).
lsort([Piv|Ls], Ans) :-
        length(Piv, PivL),
        lgt(PivL, Ls, Gt),
        lle(PivL, Ls, Lt),
        lsort(Lt, Lt1),
        lsort(Gt, Gt1),
        append([Lt1, [Piv], Gt1], Ans).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     ?- lfsort([[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],L).
%%     L = [[i, j, k, l], [o], [a, b, c], [f, g, h], [d, e], [d, e], [m, n]]


%%     Example:
%%     ?- lfsort([[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],L).
%%     L = [[i, j, k, l], [o], [a, b, c], [f, g, h], [d, e], [d, e], [m, n]]

%%     Note that in the above example, the first two lists in the result L have length 4 and 1, both lengths appear just once. The third and forth list have length 3 which appears, there are two list of this length. And finally, the last three lists have length 2. This is the most frequent length.

add_length_tag([], []).
add_length_tag([Xa|Xd], [[Xlen, Xa]|Yd]) :-
        length(Xa,Xlen),
        add_length_tag(Xd, Yd).

get_les(Len, [], []).
get_les(Len, [[Xlen, X]|Ls], [[Xlen, X]|R]) :-
        Xlen =< Len,
        get_les(Len, Ls, R).
get_les(Len , [[Xlen, X]|Ls], R) :-
        Xlen > Len,
        get_les(Len ,Ls, R).

get_gts(Len, [], []).
get_gts(Len, [[Xlen,X]|Ls], [[Xlen,X]|R]) :-
        Xlen > Len,
        get_gts(Len, Ls, R).
get_gts(Len , [[Xlen,X]|Ls], R) :-
        Xlen =< Len,
        get_gts(Len ,Ls, R).

sort_by_length_tag([], []).
sort_by_length_tag([[PivL,Piv]|Ls], Ans) :-
        get_gts(PivL, Ls, Gt),
        get_les(PivL, Ls, Lt),
        sort_by_length_tag(Lt, Lt1),
        sort_by_length_tag(Gt, Gt1),
        append([Lt1, [[PivL,Piv]], Gt1], Ans).

lfsort_transfer(X,[],[],[X]).
lfsort_transfer([X,XX],[[Y,YY]|Ys],[[Y,YY]|Ys],[[X,XX]]) :- X \= Y.
lfsort_transfer([X,XX],[[X,YY]|Xs],Ys,[[X,XX]|Zs]) :-
        lfsort_transfer([X,YY],Xs,Ys,Zs).

lfsort_pack([],[]).
lfsort_pack([X|Xs],[Z|Zs]) :- transfer2(X,Xs,Ys,Z), lfsort_pack(Ys,Zs).

remove_length_tag([], []).
remove_length_tag([[_,Xa]|Xd], [Xa|Rd]) :-
        remove_length_tag(Xd, Rd).

lfsort([],[]).
lfsort(X,Ans) :-
        add_length_tag(X, X1),
        sort_by_length_tag(X1,X2),
        lfsort_pack(X2,X3),
        lsort(X3,X4),
        append(X4,X5),!,
        remove_length_tag(X5,Ans).


%?- lfsort([[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],L).
%L = [[i, j, k, l], [o], [f, g, h], [a, b, c], [m, n], [d, e], [d, e]].


%range(2,19,X),member(XX,X),Y is XX rem 2,Y \== 0.
%
%forall((range(2,19,X),member(XX,X),Y is XX rem 2,Y \== 0),Y)
%
%
%remove_foo(_,[],[]).
%remove_foo(N,[Xa|Xd],Ad) :-
%        Tem is Xa rem N,
%        Tem == 0,
%        remove_foo(Xd,Ad).
%remove_foo(N,[Xa|Xd],[Xa|Ad]) :-
%        Tem is Xa rem N,
%        Tem \== 0,
%        remove_foo(Xd,Ad).

%% P31 (**) Determine whether a given integer number is prime.
%%     Example:
%%     ?- is_prime(7).
%%     Yes


% ほぼ写経
is_prime(1) :- false.
is_prime(2) :- true.
is_prime(N) :- N > 2, N mod 2 =\= 0, \+ has_factor(N, 2).

has_factor(N, L) :- N mod L =:= 0.
has_factor(N, L) :- L * L < N,
        L2 is L + 2,
        has_factor(N, L2).



%% 2.02 (**) Determine the prime factors of a given positive integer.
%%     Construct a flat list containing the prime factors in ascending order.
%%     Example:
%%     ?- prime_factors(315, L).
%%     L = [3,3,5,7]

prime_factors(N, [N]) :- is_prime(N).
prime_factors(N, [H|T]) :- prime_factors()

has_factors(N, L) :- N mod L =:= 0.
has_factor(N, L) :- L * L < N,
        L2 is L + 2,
        has_factor(N, L2).






next_factor(_,2,3) :- !.
next_factor(N,F,NF) :- F * F < N, !, NF is F + 2.
next_factor(N,_,N).                                 % F > sqrt(N)

(if (< (* f f) n)
    (is nf (+ f 2))
    (= n nf))



% (if t "foo" "bar")

foo(true, 'foo') :- !.
foo(_, 'bar').


% 2.02 (**) Determine the prime factors of a given positive integer.

% prime_factors(N, L) :- N is the list of prime factors of N.
%    (integer,list) (+,?)

prime_factors(N,L) :- N > 0,  prime_factors(N,L,2).

% prime_factors(N,L,K) :- L is the list of prime factors of N. It is
% known that N does not have any prime factors less than K.

prime_factors(1,[],_) :- !.
prime_factors(N,[F|L],F) :-                           % N is multiple of F
   R is N // F, N =:= R * F, !, prime_factors(R,L,F).
prime_factors(N,L,F) :-
   next_factor(N,F,NF), prime_factors(N,L,NF).        % N is not multiple of F


% next_factor(N,F,NF) :- when calculating the prime factors of N
%    and if F does not divide N then NF is the next larger candidate to
%    be a factor of N.

next_factor(_,2,3) :- !.
next_factor(N,F,NF) :- F * F < N, !, NF is F + 2.
next_factor(N,_,N).                                 % F > sqrt(N)
