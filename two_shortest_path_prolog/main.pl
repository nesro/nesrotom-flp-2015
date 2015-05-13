% MI-FLP FitBreak {nesrotom,tatarsan}@fit.cvut.cz
% run as: swipl -s main.pl -g main -t halt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this works in a different way than C and LISP's bellman ford approach
% because here we are finding all possible paths, so we can travel though
% edges with negative weights.
% first, we find the shortest path from the first node to the last
% and for each edge in this path, we remove it in both ways and then add one
% edge in the opposite direction then before with negative weight

% main function reads the number of nodes and if it's not zero, calls the work
% function and then itself again
main :-
	n(N), % load the number of nodes into N
	(N > 0 -> w(N), main). % if N is greater than 0, do the work and repeat

% w = work(+Nodes),
% first, loads the number of edges of the graph
% second, loads the edges into a list
% third, for each edge, create the two edges in the graph
% fourth, create 2 nodes with 8 long edges from the first to the nth node
% fifth, get the lenght of the "forth and back" path
% sixth, write a solution
% seventh, delete all edges, because we can do multiple graphs per run of prog
w(N) :-
	n(M), % read the number of edges into M
	l(M, E), % load edges into E
	maplist(ae, E), % for each edge, call add_edge
	TMP1 is N + 98, % create two nodes for catching "no solution"
	TMP2 is N + 99,
	ae([TMP1, 1, 10000]),
	ae([TMP1, N, 10000]),
	ae([TMP2, 1, 10000]),
	ae([TMP2, N, 10000]),
	j(1,N,L), % jail. forth and back in the graph
	(L > 999 -> writeln('Back to jail') ; writeln(L)), % print solution
	retractall(e(_,_,_)). % delete all edges

% n = number(-Number)
% this function reads a single number from a line
n(N) :-
	read_line_to_codes(user_input,C), % saves whole line to a list C as
	                                  % a number of ascii codes
	number_codes(N,C). % convert ascii codes into a number

% p = path(+From, +To, -Path, -Length)
% get ALL paths from one node to the other
p(A,B,P,L) :- 
	t(A,B,[A],Q,L), % travel From-To, path starts with the first node
	                % store the results in Q and L
	reverse(Q,P). % the result is from the back to the front, we need to
	              % reverse it

% t = travel(+From, +To, +Visited, -Path, -Length)
% travels all possible paths from A to B
t(A,B,P,[B|P],L) :- % path is [B|P], it's the target node with visited nodes
                    % ie: we have visited some nodes, and now we get to the
                    % target
	e(A,B,L). % there is an edge from A to B. we can return the length of
	          % the path as weight of this edge. the rest of the path
	          % and lenght will be computed in recursion tail
t(A,B,V,P,L) :-
	e(A,C,D), % get all adj nodes of A into C and its weights into D
	C \== B,  % we do not want those edges leading to the target
	          % then we would call t where the target node has been visited
	\+member(C,V), % \+ is negation: true if C is not visited yet
	t(C,B,[C|V],P,L1), % travel from C to the target node. 
	                   % [C|V] adds the C into list of visited nodes
	                   % path and length will be computed in recursion
	L is D + L1. % the lenght is the weight of the current edge and from
	             % what we will get

% s = shortest_path(+From, +To, -Path, -Length).
% find the shorstest path from A to B and return the path in P and lenght in L
% the heart of this function is the setof function:
% setof(+Template, +Goal, -Set) finds all solutions to the goal with the
% template and the lists of templates is returned in the Set
s(A,B,P,L) :-
	setof(
		[P2,L2], % template is [Path (list), Length (number)]
		p(A,B,P2,L2), % the goal is to find a path from A to B
		S), % result in S is the list of [Path (list), Lenght (number)]
	S = [_|_], % if there is no path from A to B at all, the minimum
	           % function would not work
	m(S,[P,L]). % from all the paths with their lenghts, get the shortest
	            % one

% m = minumum(+List, -Minimum), M is a list of [Path, Lenght]
m([F|R],M) :-
	mh(R,F,M). % TmpMinimum is the first item in the list
% mh = helper_minimum(+Rest, +TmpMinimum, -ResultMinimum)
mh([],M,M). % if there is no rest in the list, Result is the last item
mh([[FP,FL]|R],[MP,ML],Min) :- % get the front path and its lenght info FP, FL
                               % and TmpMinimum into MP and ML
	(FL < ML -> % is the front lenght lesser than the TmpMinimum?
		!, % do not backtrack
		mh(R,[FP,FL],Min) % call the minimum helper with the new minimum
	; % or if not
		mh(R,[MP,ML],Min) % call the minimum helper with the new minimum
	).

% f = first_element_of_list(-First, +List)
f(F, [F|_]).

% r = reverse_edges(+Path)
% the input argument is the shortests path from the first to the nth node.
% we take the first item and the first item of the rest of the path
% and reverse the edges in way
r([]). % if there is no path, do nothing
r([_]). % if there is the last node in the path, do nothing, because we cannot
        % take the first item of the rest
r([A|T]) :- 
	f(B, T), % B is the first item of the tail T
	e(A,B,L), % L is the weight of the edge between A and B
	N is -L, % N is the new weight of the edge. just reverset the original
	retract(e(A,B,L)), % remove the old edge from A to B 
	retract(e(B,A,L)), % remove the old edge from B to A 
	assert(e(B,A,N)), % create the new edge from B to A with the new length
	r(T). % recursive call with the tail T

% j = jail(+From,+To,-Length), L,M,N = lenghs
j(F,T,L) :- 
	s(F,T,P,M), % search for the first shortest path
	r(P), % reverse the edges
	s(F,T,_,N), % search for the second shortests path
	L is M + N. % compute the result length

% ae = add_edges(+[Node1, Node2, Weigth])
ae([N1,N2,W]) :- 
	assert(e(N1,N2,W)), % add the first edge to the knowledge database
	assert(e(N2,N1,W)). % add the second edge to the knowledge database

% l = load_edges(+Nodes, -Edges)
l(0,[]). % when there is nothing to read, rest is just an empty list
l(N,[E|R]) :- % N is the number of edges (lines) to read, E is the edge that
              % that will be read in this call and R is the rest that will be
              % filled in recursion
	N > 0, % N must be greater than zero
	read_line_to_codes(user_input,L), % load ascii codes of a line
	atom_codes(A,L), % covert those codes into atoms
	atomic_list_concat(B,' ',A), % divide this lists by spaces
	maplist(atom_number,B,E), % edge is a list of numbers
	M is N - 1, % decrease the number of edges to read
	l(M,R). % call recursively to fill the rest R

