/* MI-FLP FitBreak {nesrotom,tatarsan}@fit.cvut.cz */

/* how this works for this tricky input (please take a piece of paper and draw
 * it):
 * 4 (four nodes)
 * 5 (five edges)
 * 1 2 1
 * 1 3 10
 * 2 3 1
 * 2 4 10
 * 3 4 1
 * 0 (end)
 * first, bellman-ford relaxes:
 * from 0 to 1: distance[1] is 1
 * from 0 to 2: distance[2] is 10
 * from 1 to 3: distance[3] is 11 but it is overwritten by
 * from 2 to 3: distance[3] is 3
 * we have found this shortest path from the node 0 to the node 3:
 * (3, 2) = 1
 * (2, 1) = 1
 * (1, 0) = 1
 * and by reversing these edges in the direction they WERE USED, we get:
 * (3, 2) = 1, (2, 3) = -1
 * (2, 1) = 1, (1, 2) = -1
 * (1, 0) = 1, (0, 1) = -1
 * now the bellman ford is run for the second time. please note that our
 * implementation is skipping negative weight and zero weight edges.
 * relaxes:
 * from 0 to 2: distance[2] is 10
 * from 2 to 1: distance[1] is 11
 * from 2 to 3: distance[1] is 21
 * NOW HERE COMES THE TRICKY PART:
 * we travel through the shortest path in reverse. bellman for worked with
 * weight 1 from node 2 to node 1, but the weight for edge from node 1 to node 2
 * is -1. thus, the lengths of the edges in the shortests path are:
 * (3, 1) = 10
 * (1, 2) = -1
 * (2, 0) = 10
 * we used the edge from 1 to 2 twice, but we are negating it from the result
 * so the result is right
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

#define N_MAX 100 /* maximal nodes count */
#define INF 9999 /* infinity */
#define DEBUG 0 /* set this to 1 for debugging information */

int n, /* nodes count */
    a[N_MAX][N_MAX], /* adjacency matrix */
    p[N_MAX], /* predecessor array */
    d[N_MAX]; /* distance array */

/* reverse the edges in the shortests path saved in the p array */
static void reverse_edges(void) {
	int x, /* a node in the path */
	    y; /* the predecessor node of the node x */

	x = n - 1; /* we start with the last node */
	y = p[x];
	while (y != 0) {
		a[y][x] = -a[y][x]; /* if the predecessor of node 3 is
		                     * the node 2 (we have travel from the
		                     * node 2 to the node 3), we reverse the
		                     * edge from the node 2 to the node 3 */
		if (DEBUG)
			printf("reversing: (%d, %d) = %d, (%d, %d) = %d\n", x,
			    y, a[x][y], y, x, a[y][x]);
		x = y;
		y = p[y];
	}
	a[y][x] = -a[y][x]; /* now the y is the node 0. so it is the last
	                     * predecessor */
	if (DEBUG)
		printf("reversing: (%d, %d) = %d, (%d, %d) = %d\n", x,
		    y, a[x][y], y, x, a[y][x]);
}

/* get the cost of the best path. the second best path (from node N - 1 to 0)
 * may lead through negative edges weight. */
static int cost(void) {
	int x, y, s = 0;

	x = n - 1;
	y = p[x];
	while (y != 0) {
		if (DEBUG)
			printf("shortest path (%d, %d) = %d\n", x, y, a[x][y]);
		s += a[x][y]; /* notice the [x][y], we had [y][x] when
		               * reversing */
		x = y;
		y = p[y];
	}
	if (DEBUG)
		printf("shortest path (%d, %d) = %d\n", x, y, a[x][y]);
	s += a[x][y];
	return (s);
}


/* bellman-ford's algorithm. if it reaches a zero or negative weight edge,
 * ignores it */
static void bf(void) {
	int i, j, k, t;

	for (i = 0; i < N_MAX; i++) {
		p[i] = -1;
		d[i] = INF;
	}
	d[0] = 0;
	for (k = 0;  k < n; k++) { /* do n times */
		for (i = 0;  i < n; i++) { /* for each node */
			for (j = 0;  j < n; j++) { /* and all its edges */
				if (a[i][j] <= 0) {
					continue;
				}
				t = d[i] + a[i][j];
				if (DEBUG)
					printf("k=%d i=%d, j=%d, d[i]=%d,"
					    " d[j]=%d, a[i][j]=%d t=%d\n", k,
					    i, j, d[i], d[j], a[i][j], t);
				if (t < d[j]) { /* relax */
					if (DEBUG)
						printf("relax! d[%d]=%d\n",
						    j, t);
					d[j] = t;
					p[j] = i;
				}
			}
		}
	}
}

/* loads the input into the adjacency matrix */
static int load_input(void) {
	int i = 0, j = 0, k = 0, l = 0;

	assert(scanf("%d", &n) == 1);
	if (DEBUG)
		printf("n=%d\n", n);
	if (!n) /* if the nodes count is zero, return false */
		return (0);
	assert(2 <= n && n <= N_MAX);
	assert(scanf("%d", &i) == 1);
	if (DEBUG)
		printf("i=%d\n", i);
	while (i--) {
		assert(scanf("%d %d %d", &j, &k, &l) == 3);
		j--; /* we're indexing from 0, the input is indexing from 1 */
		k--;
		if (DEBUG)
			printf("j=%d k=%d l=%d\n", j, k, l);
		assert(1 <= l && l <= 1000);
		a[j][k] = a[k][j] = l; /* load two edges, forth and back */
	}
	return (1);
}

/* if there is no predecessor of the target node, the path doesn't exists */
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
		bf(); /* the first bellman ford */
		if (back_to_jail()) {
			continue;
		}
		r = cost(); /* compute the lenght of the shortest path */
		reverse_edges(); /* reverse edges in the shortest path */
		bf(); /* the second bellman ford */
		if (back_to_jail()) {
			continue;
		}
		r += cost(); /* add the lenght of the second shortests path */
		printf("%d\n", r);
		if (DEBUG)
			printf("--- end of the graph ---\n");
	}
	return (EXIT_SUCCESS);
}

