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
max([H|T], N1, Max, N2, Min) :- max(T, N1, Max, N2, Min).

% idiomatic
max([H|[]], H, H).
max([H|T], H, Min) :- max(T, Max, Min), H >= Max, !.
max([H|T], Max, H) :- max(T, Max, Min), H =< Min, !.
max([H|T], Max, Min) :- max(T, Max, Min).
