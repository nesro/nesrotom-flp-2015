% swipl -s nesro.pl -g main -t halt
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% http://alumni.cs.ucr.edu/~vladimir/cs181/prolog_5.pdf
% https://www.cpp.edu/~jrfisher/www/prolog_tutorial/2_15.html
% https://www.cpp.edu/~jrfisher/www/prolog_tutorial/2_15A.pl

% http://www.swi-prolog.org/pldoc/doc_for?object=section(2,%274.8%27,swi(%27/doc/Manual/control.html%27))
%
% setof(+Template, +Goal, -Set)
% Equivalent to bagof/3, but sorts the result using sort/2 to get a sorted list
% of alternatives without duplicates.

% listing(ue) % show edges

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lwrite([ ]) :- nl.
lwrite([H]) :- write(H), nl.
lwrite([H | T]):- write(H), write(', '), lwrite(T).

debug([]) :- nl.
debug([H|T]):- write(H), debug(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic e/3.
% TODO: read this from file
%e(1, 2, 1).
%e(1, 3, 10).
%e(2, 3, 1).
%e(2, 4, 10).
%e(3, 4, 1).
% oposite direction
%e(2, 1, 1).
%e(3, 1, 10).
%e(3, 2, 1).
%e(4, 2, 10).
%e(4, 3, 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path(A,B,Path,Len) :- travel(A,B,[A],Q,Len), reverse(Q,Path).
travel(A,B,P,[B|P],L) :- e(A,B,L).
travel(A,B,Visited,Path,L) :- e(A,C,D), C \== B, \+member(C,Visited),
	travel(C,B,[C|Visited],Path,L1), L is D+L1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s(A,B,Path,Length) :- setof([P,L],path(A,B,P,L),Set), Set = [_|_],
	m(Set,[Path,Length]).
m([F|R],M) :- mm(R,F,M).
mm([],M,M).
mm([[P,L]|R],[_,M],Min) :- L < M, !, mm(R,[P,L],Min). 
mm([_|R],M,Min) :- mm(R,M,Min).
f(F, [F|_]).
r([]).
r([X]). %FIXME
r([A|T]) :- f(B, T), e(A,B,L), N is -L, retract(e(A,B,L)), assert(e(B,A,N)),
	r(T).

solve(F,T,L) :-
	s(F,T,Path,Len),
	r(Path),
	s(F,T,_,Len2),
	L is Len + Len2.

main :- %repeat,
	rn1(N),
	rn1(M),
	read_debts(M, Debts),
	nl,
	write('N='), writeln(N),
	write('M='), writeln(M),
	%lwrite(Debts),
	maplist(assert,Debts),
	solve(1,N,L),
	write('L='), writeln(L).

	%writeln('---------'),
	%e(1,3,XXX),
	%writeln(XXX).

read_debts(M, Debts) :-
	( M > 0 ->
		Debts = [D|Ds],
		read_line_to_codes(user_input, Line),
		atom_codes(A, Line),
		atomic_list_concat(As, ' ', A),
		maplist(atom_number, As, List),
		D =.. [e|List],
		M1 is M - 1,
		read_debts(M1, Ds)
	; M =:= 0 ->
		Debts = []
	).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
read_header_data(Stream, Header) :-
	read_line_to_codes(Stream, Header, Tail),
	write('Atail='), lwrite(Tail),
	read_header_data(Header, Stream, Tail).
read_header_data("\r\n", _, _) :- !.
read_header_data("\n", _, _) :- !.
read_header_data("", _, _) :- !.
read_header_data(_, Stream, Tail) :-
	write('tail='), lwrite(Tail),
	read_line_to_codes(Stream, Tail, NewTail),
	write('newtail='), lwrite(NewTail),
	read_header_data(Tail, Stream, NewTail).


rn1(X) :- read_line_to_codes(user_input,C), number_codes(X,C).
rn3(R1) :-
	read_line_to_codes(user_input,C),
	%write('C='), lwrite(C),
	atom_codes(B, C),
	%write('B='), lwrite(B),
	atomic_list_concat(D,' ',B),
	write('D='), lwrite(D),
	%atomic_list_concat(D, -, NES),
	%write('N='), lwrite(NES),
	%number_codes(E,D),
	%write('E='), lwrite(E),
	f(R1,D),
	number_chars(TEST,D),
	write(TEST), nl,
	(R1 =:= 15 -> write(yes) ; write(no)).
	%atom_number(R1,tR1).

	%number_codes(R2,QQQ).
	%atom_codes(B, C),
	%write('B='), lwrite(B),
	%atomic_list_concat(C, ' ', D),
	%lwrite('D='), write(D),
	%R2 is 99,
	%R3 is 666.

	%atom_codes(A, Cs),
	%atomic_list_concat(B, ' ', A),
	%	lwrite(B),
	%	number_codes(X,B).

	iszero(X) :- (X =:= 0 -> true ; false).

main3 :-
	%repeat,
	rn1(X),
	nl,
	write('X = '), writeln(X),
	rn1(Y),
	write('Y = '), writeln(Y),
	writeln('-----------------'),
	rn3(A),
	write('A='), writeln(A).
%iszero(A).
%rn3(A, B, C),
%	write('A,B,C = '), writeln(A), writeln(B), writeln(C).

%rn1(B),
%write('B = '), writeln(B).
%(iszero(X) -> ! ; writeln('no')).

% http://courses.softlab.ntua.gr/pl1/2012a/Exercises/





main2 :- nl, nl, nl, nl,
	s(1,4,Path,Len),
	write('PATH= '), lwrite(Path),
	write('LENGTH= '), write(Len), nl,
	r(Path),
	listing(e),
	s(1,4,Path2,Len2),
	write('PATH= '), lwrite(Path2),
	write('LENGTH= '), write(Len2), nl,
	Len3 is Len + Len2,
	write(Len3), nl.
