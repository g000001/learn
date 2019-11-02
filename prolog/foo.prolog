
(40 - 32) ÷ 2 = 4
40 - 32 ÷ 2 = 4!

fact(0,1) :- !.
fact(N,Ans) :- N1 is N - 1, fact(N1, Ans1), Ans is N * Ans1.

ans(A,B,C,D) :- D < 100.

ans(A,B,C,D) :- D is (A - B) / C, D1 is D + 1,ans(A,B,C,D1).

ans(A,B,C,D) :- X is (A - B / 2), fact(D,X).

ans :- (A - B) / C.


between(S,E,[], []).
between(S,E,[H|T],[H|T1]) :-
    S =< H,
    H =< E,
    between(S,E,T,T1).
between(S,E,[H|T],T1) :-
    (S > H) | (H > E),
    between(S,E,T,T1).
