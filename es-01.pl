% 1.1) search2(Elem, List)
% looks for two consecutive occurrences of Elem
% search2(a, [a,b,a,a,b,a]) -> yes
% search2(a, [a,b,a,b,b,a]) -> no
search2(E, [E,E|_]) :- !.
search2(E, [_|T]) :- search2(E, T).



% 1.2)search_two(Elem,List)
% looks for two occurrences of Elem with any element in between!
% search_two(a,[b,c,a,a,d,e]). → no
% search_two(a,[b,c,a,d,a,d,e]). → yes
search_two(E, [E,X,E|_]) :- E \= X, !.
search_two(E, [_|T]) :- search_two(E, T).



% 1.3) size(+List, -Size)
% Size will contain the number of elements in List
% size([1,2,3], N). -> yes N/3
% not fully relational
size([], 0).
size([_|T], N) :- size(T, N2), N is N2 + 1.



% 1.4) sum(+List, -Sum)
% sum([1,2,3],X). -> yes X/6
% not fully relational
sum([], 0).
sum([H|T], N) :- sum(T, N2), N is N2 + H.



% 1.5) max(+List, -Max, -Min)
% Max is the biggest element in List
% Min is the smallest element in List
% Suppose the list has at least one element
% max([1,2,3,4,3,2,1,0,1], Max, Min). yes. -> Max / 4, Min / -1

% performance
%max([H|T], Max, Min) :- max(T, H, Max, H, Min).
max([], Max, Max, Min, Min).
max([H|T], N1, Max, N2, Min) :- H >= N1, max(T, H, Max, N2, Min), !.
max([H|T], N1, Max, N2, Min) :- H =< N2, max(T, N1, Max, H, Min), !.
max([_|T], N1, Max, N2, Min) :- max(T, N1, Max, N2, Min).

% idiomatic
max([H|[]], H, H).
max([H|T], H, Min) :- max(T, Max, Min), H >= Max, !.
max([H|T], Max, H) :- max(T, Max, Min), H =< Min, !.
max([_|T], Max, Min) :- max(T, Max, Min).



% 1.6) sublist(?List1, +List2)
% List1 should contain elements all also in List2
% example: sublist([1,2],[5,3,2,1]).
sublist([], _).
sublist([H|T], L) :- member(H, L), sublist(T, L).



% 2.1) dropAny(?Elem,?List,?OutList)
% Drops any occurrence of element
% dropAny(10,[10,20,10,30,10],L)
% L/[20,10,30,10]
% L/[10,20,30,10]
% L/[10,20,10,30]
dropAny(X, [X | T], T).
dropAny(X, [H | Xs], [H | L]) :- dropAny(X, Xs, L).

% 2.2) others drops

% 2.2.a) dropFirst(?Elem,?List,?OutList)
% drops only the first occurrence (showing no alternative results)
% dropFirst(10,[20,10,20,10,30,10],L). -> yes L / [20,20,10,30,10]
dropFirst(X, [X | T], T) :- !.
dropFirst(X, [H | Xs], [H | L]) :- dropFirst(X, Xs, L).

% 2.2.b) dropLast(?Elem,?List,?OutList)
% drops only the last occurrence (showing no alternative results)
% dropLast(10,[10,20,10,30,10,20],L). -> yes L / [10,20,10,30,20]
dropLast(X, [H | Xs], [H | L]) :- dropLast(X, Xs, L), !.
dropLast(X, [X | T], T).

% 2.2.c) dropAll(?Elem,?List,?OutList)
% drop all occurrences, returning a single list as a result
% dropAll(10,[10,20,10,30,10,20],L). -> yes L / [20,30,20]
dropAll(_, [], []).
dropAll(X, [X | T], L) :- dropAll(X, T, L), !.
dropAll(X, [H | T], [H | L]) :- X \= H, dropAll(X, T, L).
