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



% 1.3) size(List , Size)
% Size will contain the number of elements in List
% size([1,2,3], N). -> yes N/3
% not fully relational
size([], 0).
size([_|T], N) :- size(T, N2), N is N2 + 1.
