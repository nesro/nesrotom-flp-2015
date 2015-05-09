/* MI-FLP FitBreak {nesrotom,tatarsan}@fit.cvut.cz */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#define N_MAX 100 /* maximalni pocet uzlu */
#define INF 9999 /* nekonecno */
#define DEBUG 0

int n, /* pocet uzlu */
    a[N_MAX][N_MAX], /* matice sousednosti */
    p[N_MAX], /* pole predchudcu */
    d[N_MAX]; /* pole vzdalenosti */

/* tam, kudy vedla nejlepsi cesta da zapornou hranu stejny velikosti.
 * POZOR! jen v jednom smeru! */
static void reverse_edges(void) {
	int x, y;

	x = n - 1;
	y = p[x];
	while (y != 0) {
		a[y][x] = -a[y][x];
		x = y;
		y = p[y];
	}
	a[y][x] = -a[y][x];
}

/* vrati cenu nejlepsi cesty. POZOR: druha nejlepsi cesta muze jit pres hrany,
 * ktery jsme uz pouzili, to nam ale nevadi, protoze TY hrany budou zaporny
 * a odectou se :) */
static int cost(void) {
	int x, y, s = 0;

	x = n - 1;
	y = p[x];
	while (y != 0) {
		if (DEBUG)
			printf("(%d, %d) = %d\n", x, y, a[x][y]);
		s += a[x][y];
		x = y;
		y = p[y];
	}
	if (DEBUG)
		printf("(%d, %d) = %d\n", x, y, a[x][y]);
	s += a[x][y];
	return (s);
}

/* bellman forduv algoritmus. poku narazi na hranu, ktera je nulova nebo
 * zaporna, tak ji ignoruje */
static void bf(void) {
	int i, j, k, t;

	for (i = 0; i < N_MAX; i++) {
		p[i] = -1;
		d[i] = INF;
	}
	d[0] = 0;
	for (k = 0;  k < n; k++) {
		for (i = 0;  i < n; i++) {
			for (j = 0;  j < n; j++) {
				if (a[i][j] <= 0) {
					continue;
				}
				t = d[i] + a[i][j];
				if (DEBUG)
					printf("k=%d i=%d, j=%d, d[i]=%d,"
					    " d[j]=%d, a[i][j]=%d t=%d\n", k,
					    i, j, d[i], d[j], a[i][j], t);
				if (t < d[j]) {
					if (DEBUG)
						printf("   relax!\n");
					d[j] = t;
					p[j] = i;
				}
			}
		}
	}
}

static int load_input(void) {
	int i = 0, j = 0, k = 0, l = 0;

	assert(scanf("%d", &n) == 1);
	if (DEBUG)
		printf("n=%d\n", n);
	if (!n)
		return (0);
	assert(2 <= n && n <= N_MAX);
	assert(scanf("%d", &i) == 1);
	if (DEBUG)
		printf("i=%d\n", i);
	while (i--) {
		assert(scanf("%d %d %d", &j, &k, &l) == 3);
		j--;
		k--;
		if (DEBUG)
			printf("j=%d k=%d l=%d\n", j, k, l);
		assert(1 <= l && l <= 1000);
		a[j][k] = a[k][j] = l;
	}
	return (1);
}

static int back_to_jail(void) {
	if (p[n - 1] == -1) {
		printf("Back to jail\n");
		return (1);
	}
	return (0);
}

int main(void) {
	int r;
	while (load_input()) {
		bf();
		if (back_to_jail()) {
			continue;
		}
		r = cost();
		reverse_edges();
		bf();
		if (back_to_jail()) {
			continue;
		}
		r += cost();
		printf("%d\n", r);
	}
	return (EXIT_SUCCESS);
}

