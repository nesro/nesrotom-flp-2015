% authors: {nesrotom,tatarsan}@fit.cvut.cz
% run as: swipl -s main.pl -g main -t halt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% p = path(From, To, Path, Length)
p(A,B,P,L) :- t(A,B,[A],Q,L), reverse(Q,P).

% t = travel(From, To, Visited, Path, Length)
t(A,B,P,[B|P],L) :- e(A,B,L).
t(A,B,V,P,L) :- e(A,C,D), C \== B, \+member(C,V), t(C,B,[C|V],P,L1), L is D+L1.

% s = shortest_path(from, to, path, length). F=from, T=to. m=minimum
s(A,B,P,L):- setof([F,T], p(A,B,F,T),S), S = [_|_], m(S,[P,L]).

% m = minumum(List, Minimum), F=First, R=Rest, M=Minimum
m([F|R],M):-mm(R,F,M).
mm([],M,M).
mm([[P,L]|R],[_,M],Min):-L<M,!,mm(R,[P,L],Min).
mm([_|R],M,Min):-mm(R,M,Min).

% f = first_element_of_list(First, List)
f(F, [F|_]).

% r = reverse_edges(Path)
r([]).
r([X]). % FIXME TODO ???????? !!!!!!!!!! ??????????? !!!!!!!!!!!! ???????
r([A|T]):-f(B, T), e(A,B,L), N is -L, retract(e(A,B,L)), assert(e(B,A,N)), r(T).

% j = jail(from,to,lenght), L,M,N = lenghs
j(F,T,L) :- s(F,T,P,M), r(P), s(F,T,_,N), L is M + N.

% n = number(Number)
n(X) :- read_line_to_codes(user_input,C), number_codes(X,C).

% element_at(ElementAtK, List, K)
ea(X,[X|_],1).
ea(X,[_|L],K):-ea(X,L,K1), K is K1 + 1.

% ae = add_edges([Node, Node, Weigth])
ae(E) :- ea(F,E,1), ea(T,E,2), ea(L,E,3), assert(e(F,T,L)), assert(e(T,F,L)).

% the all mighty main function
main :- repeat, n(N), (N =:= 0 -> ! ; w(N), main).

% w = work(Nodes), this does the work: load edges, computes and print the path
w(N) :-
	n(M),
	l(M, Debts),
	maplist(ae,Debts),
	TMP1 is N + 98,
	TMP2 is N + 99,
	ae([TMP1, 1, 10000]),
	ae([TMP1, N, 10000]),
	ae([TMP2, 1, 10000]),
	ae([TMP2, N, 10000]),
	listing(e),
	j(1,N,L),
	( L > 999 -> writeln('Back to jail') ; writeln(L)),
	retractall(e(_,_,_)).
	

% l = load_edges(Nodes, Edges), this is magic - do not touch
l(M,E) :-
	( M > 0 ->
		E = [D|Ds],
		read_line_to_codes(user_input, Line),
		atom_codes(A, Line),
		atomic_list_concat(As, ' ', A),
		maplist(atom_number, As, List),
		D =.. [List],
		M1 is M - 1,
		l(M1, Ds)
	; M =:= 0 ->
		W = []
	).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write a list, good for  debugging :)
%writel([ ]) :- nl.
%writel([H]) :- write(H), nl.
%writel([H | T]):- write(H), write(', '), lwrite(T).
