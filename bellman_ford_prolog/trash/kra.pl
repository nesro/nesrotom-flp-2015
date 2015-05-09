/* 2. cviceni na prolog */
/* ******************** */
/*
	= se dotazuje na unifikaci, tedy zdali lezi na stejnem miste v pameti
	\ je negace. Napr. \= ...
	?- X = 3; Y = 5; X =:= Y popr 3 =:= 5
	=:= je aritmeticka rovnost
	=\= je aritmeticka nerovnost
	?- X = 2+1, vrati 2+1
	?- X == Y je porovnani bez unifikace
*/
bod(X,Y):- number(X),number(Y).
usecka(bod(X,Y),bod(U,V)).

%svisla(Usecka)
svisla(usecka(bod(X,Y),bod(U,V))):- X=:=U.
%nebo
svisla2(usecka(bod(X,Y),bod(X,V))).
/*
spousti se to jako:
?- svisla(usecka(bod(2,3),bod(3,5))).
*/

/* Obdelnik */
/* Dle vodorovneho smeru. */
obdelnik(bod(X,Y),bod(X2,Y),bod(X2,Y2),bod(X,Y2)):- X\=X2, Y\=Y2.

/* Delka usecky */
delka(usecka(bod(X,Y),bod(U,V)),D):- svisla(usecka(bod(X,Y),bod(U,V))),
	D is V-Y.
/* nebo */
delka2(Us,D):- Us=usecka(bod(X,Y),bod(U,V)),svisla(Us),D is V-Y.

/*
	Seznamy:
				[] ... prazdny senzam
				nil... prazdny seznam
				[a,b,c,d]
				[Hlava|Tělo]... neco jako car a cdr
				[H1,H2,H3|Tělo]
*/

