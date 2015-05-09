
:- dynamic e/3.
e(1,2,3).
e(1,2,4).

main :-
	e(1,2,B),
	write('B='), write(B), nl,
	asserta(e(1,2,4)),
	e(1,2,A),
	write('A='), write(A), nl.



	%retract(e(1,2,4)),
	%assert(e(1,2,4)),
	%listing(e(1,2,4)),
	%redefine_system_predicate(e(1,2,4)),
