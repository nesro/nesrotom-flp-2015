writeMyName(X):- write([my, name, is, X]), nl.

% http://alumni.cs.ucr.edu/~vladimir/cs181/prolog_5.pdf
writelist([ ]):- nl.
writelist([H | T]):- write(H), write(,), tab(5), writelist(T).

main :- read(X), writelist([hello, X]).
