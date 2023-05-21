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
dropAll(X, [X | T], L) :- dropAll(X, T, L).
dropAll(X, [H | T], [H | L]) :- X \= H, dropAll(X, T, L).



% fromList(+List,-Graph)
% fromList([1,2,3],[e(1,2),e(2,3)]).
% fromList([1,2],[e(1,2)]).
% fromList([1],[]).
fromList([_],[]).
fromList([H1,H2|T],[e(H1,H2)|L]):- fromList([H2|T],L).



% fromCircList(+List,-Graph)
% fromCircList([1,2,3],[e(1,2),e(2,3),e(3,1)]).
% fromCircList([1,2],[e(1,2),e(2,1)]).
% fromCircList([1],[e(1,1)]).
fromCircList([F|T], G) :- fromCircList([F|T], F, G).
fromCircList([H|[]], F, [e(H,F)]).
fromCircList([H1,H2|T], F, [e(H1,H2)|L]) :- fromCircList([H2|T], F, L).



%outDegree(+Graph, +Node, -Deg)
% Deg is the number of edges leading into Node
% outDegree([e(1,2), e(1,3), e(3,2)], 2, 0).
% outDegree([e(1,2), e(1,3), e(3,2)], 3, 1).
% outDegree([e(1,2), e(1,3), e(3,2)], 1, 2).
outDegree([], _, 0).
outDegree([e(N,_)|T], N, D) :- outDegree(T, N, D2), D is D2+1, !.
outDegree([e(H,_)|T], N, D) :- H \= N, outDegree(T, N, D).



% dropNode(+Graph, +Node, -OutGraph)
% drop all edges starting and leaving from a Node
% use dropAll defined in 1.1?? NO, drop just the first occurence of e(N,_)
% dropNode([e(1,2),e(1,3),e(2,3)],1,[e(2,3)]).
dropNode(G, N, GO):- dropAll(e(N,_), G, G2), dropAll(e(_,N), G2, GO).



% reaching(+Graph, +Node, -List)
% all the nodes that can be reached in 1 step from Node
% possibly use findall , looking for e(Node ,_) combined
% with member(?Elem,?List)
% reaching([e(1,2),e(1,3),e(2,3)],1,L). -> L/[2,3]
% reaching([e(1,2),e(1,2),e(2,3)],1,L). -> L/[2,2]).
reaching(G, N, L) :- findall(E, member(e(N,E), G), L).



% nodes (+Graph , -Nodes)
% create a list of all nodes (no duplicates) in the graph (inverse of fromList)
% nodes([e(1,2),e(2,3),e(3,4)],L). -> L/[1,2,3,4]
% nodes([e(1,2),e(1,3)],L). -> L/[1,2,3].
nodes([], []).
nodes([e(N1, N2)|T], L) :- nodes(T, L), member(N1,L), member(N2,L), !.
nodes([e(N1, N2)|T], [N2|L]) :- nodes(T, L), member(N1,L), !.
nodes([e(N1, N2)|T], [N1|L]) :- nodes(T, L), member(N2,L), !.
nodes([e(N1, N2)|T], [N1,N2|L]) :- N1 \= N2, nodes(T, L), !. % e(1,1)
nodes([e(N1, N1)|T], [N1|L]) :- nodes(T, L).



% anypath(+Graph, +Node1, +Node2, -ListPath)
% a path from Node1 to Node2
% if there are many path , they are showed 1-by -1
% anypath([e(1,2),e(1,3),e(2,3)],1,3,L).
%  -> L/[e(1,2),e(2,3)]
%  -> L/[e(1,3)]
anypath(G, N1, N2, [e(N1, N2)]) :- member(e(N1,N2), G).
anypath(G, N1, N2, [e(N1,N3)|L]) :- member(e(N1, N3), G), anypath(G, N3, N2, L).




% allreaching(+Graph, +Node, -List) 2
% all the nodes that can be reached from Node
% Suppose the graph is NOT circular!
% Use findall and anyPath!
% allreaching([e(1,2),e(2,3),e(3,5)],1,[2,3,5]).
allreaching(G, N, L) :- findall(E, anypath(G, N, E, _), L).



% 3.9) ???

interval(A, B, A).
interval(A, B, X) :- A2 is A+1, A2 < B, interval(A2, B, X).

neighbour(A, B, A, B2):- B2 is B+1.
neighbour(A, B, A, B2):- B2 is B-1.
neighbour(A, B, A2, B):- A2 is A+1.
neighbour(A, B, A2, B):- A2 is A-1.

gridlink(N, M, e(X2, Y2)):- 
    interval(0, N, X),
    interval(0, M, Y),
    neighbour(X, Y, X2, Y2),
    X2 >= 0, Y2 >= 0, X2 < N, Y2 < M.


% 4.1) next
% next([n,n,n,n,n,n,n,n,n], x, ???, N). N / [x,n,n,n,n,n,n,n,n], ..., [n,n,n,n,n,n,n,n,x].

next(Table, Player, Result, NewTable) :-
	interval(0, 9, X),
	move(Table, X, Player, NewTable).

move([n|T], 0, Player, [Player|T]).
move([H|T], 0, Player, [H|T]) :- H \= n.
move([H|T], N, Player, [H|NewTable]) :- N2 is N-1, move(T, N2, Player, NewTable).


	





