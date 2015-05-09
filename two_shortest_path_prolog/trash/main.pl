% {nesrotom,tatarsan}@fit.cvut.cz
%

:-op(400, xfy, ->).
:-op(500, xfx, /).

g_vertices(Gid, Vertices) :-
	g(Gid, Vertices, _).

g_edges(Gid, Edges) :-
	g(Gid, _, Edges).

g_vertex(Gid, Vertex) :-
	g_vertices(Gid, Vertices),
	member(Vertex, Vertices).

%% Bellman-Ford

% bf(+Gid, +Start, +Stop, ?Cost, -Path) (+Cost does not make sense, though)
bf(Gid, Start, Stop, Cost, Path) :-
	g_vertex(Gid, Start),
	g_vertex(Gid, Stop),
	retractall(bf_shortest(Gid, _)),
	bf_set_shortest(Gid, nill->Start/0),
	g_edges(Gid, Edges),
	length(Edges, M),
	bf_loop(Gid, M),
	bf_path_summary(Gid, Start, Stop, Cost, Path),
	retractall(bf_shortest(Gid, _)),
	!.

bf_set_shortest(Gid, From->To/Cost) :-
	retract(bf_shortest(Gid, From->To/_)),
	asserta(bf_shortest(Gid, From->To/Cost)),
	!.
bf_set_shortest(Gid, From->To/Cost) :-
	asserta(bf_shortest(Gid, From->To/Cost)).

bf_visited(Gid, Vertex) :-
	bf_shortest(Gid, _->Vertex/_).

bf_loop(_, 0) :- !.
bf_loop(Gid, M) :-
	Mnext is M - 1,
	bf_explore(Gid),
	bf_loop(Gid, Mnext).

bf_explore(Gid) :-
	g_vertices(Gid, Vertices),
	bf_explore(Gid, Vertices).

bf_explore(_, []) :- !.
bf_explore(Gid, [Vertex|Rest]) :-
	bf_visited(Gid, Vertex),
	bf_update(Gid, Vertex),
	bf_explore(Gid, Rest),
	!.
bf_explore(Gid, [_|Rest]) :-
	bf_explore(Gid, Rest).

bf_update(Gid, Vertex) :-
	findall(Vertex->To/Cost,
	(
		g_edges(Gid, E), 
		member(Vertex->To/Cost, E)
	), Adjacent),
	bf_update_path(Gid, Vertex, Adjacent).

bf_update_path(_, _, []) :- !.
bf_update_path(Gid, From, [From->To/Cost|Rest]) :-
	bf_shortest(Gid, _->To/TCost),
	bf_shortest(Gid, _->From/FCost),
	PCost is FCost + Cost,
	bf_update_record(Gid, From->To, TCost, PCost),
	bf_update_path(Gid, From, Rest),
	!.
bf_update_path(Gid, From, [From->To/Cost|Rest]) :-
	bf_shortest(Gid, _->From/FCost),
	PCost is FCost + Cost,
	bf_set_shortest(Gid, From->To/PCost),
	bf_update_path(Gid, From, Rest).

bf_update_record(_, _, OldCost, NewCost) :-
	OldCost =< NewCost,
	!.
bf_update_record(Gid, From->To, OldCost, NewCost) :-
	NewCost < OldCost,
	bf_set_shortest(Gid, From->To/NewCost).

bf_path_summary(Gid, Start, Stop, Cost, Path) :-
	bf_shortest(Gid, _->Stop/Cost),
	bf_assemble_path(Gid, Start, [Stop], Path).

bf_assemble_path(_, Start, [Start|RAcc], [Start|RAcc]) :- !.
bf_assemble_path(Gid, Start, Acc, Path) :-
	[To|_] = Acc,
	bf_shortest(Gid, From->To/_),
	bf_assemble_path(Gid, Start, [From|Acc], Path).
