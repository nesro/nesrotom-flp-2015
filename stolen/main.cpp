/* TOHLE JE UZ CASTECNE MNOU UPRAVENA VERZE, KTERA PO UPRAVENI/OBFUSKACI/
 * ZJEDNODUSENI PRIJDE ODEVZDAT = PLS NEKOPIROVAT 1:1 / poradit se mnou pred
 * odevzdavanim */
/*
 * I stole it, tbh :) lol
 * popis algoritmu:
 * http://matrixsust.blogspot.cz/2011/01/successive-shortest-paths-algorithm.html
 * zdrojovy kod:
 * http://matrixsust.blogspot.cz/2011/01/minimum-cost-maxflowmincut-maxflow.html
 * zadani ulohy (tok v grafu. pro nase potreby tok=2 kapacita=1)
 * http://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&category=116&page=show_problem&problem=1535
 */
#include <iostream>
#include <string>
#include <vector>
#include <queue>
#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

using namespace std;
#define MV 102 /* maximal number of vertices */

int  cst[MV][MV],
     cap[MV][MV],
     par[MV],
     dis[MV],
     source,
     sink,
     flow;

vector<int> adj[MV]; /* array of neighbours */

/* this is needed for STL C++ priority queue */
struct pq {
	int d, n;
	void ini(int a, int b) {
		n = a;
		d = b;
	}
	bool operator<(const pq &b) const{
		return (d > b.d);
	}
};

bool PFS(int s, int sk) {
	priority_queue<pq> Q;
	pq u,v;
	int i;
	long long int alt;

	memset(dis, 99, sizeof (dis));
	dis[s] = 0;
	u.ini(s, 0);
	Q.push(u);

	while (!Q.empty()) {
		u = Q.top();
		Q.pop();
		for (i = 0; i < (int) adj[u.n].size(); i++) {
			alt =dis[u.n]+cst[u.n][adj[u.n][i]]; 
			if (cap[u.n][adj[u.n][i]] &&
			    alt<dis[adj[u.n][i]]) {
				dis[adj[u.n][i]] = alt;
				v.ini(adj[u.n][i],dis[adj[u.n][i]]);
				Q.push(v);
				par[adj[u.n][i]]=u.n;
			}
		}
	}

	return (dis[sk] < dis[0]);
}

void MakeResidal(int u) {
	cst[par[u]][u]=cst[u][par[u]]=-cst[par[u]][u];
	cap[u][par[u]]++;
	cap[par[u]][u]--;
	if (u!=1) {
		MakeResidal(par[u]);
	}
}

int MinCostFlow(int s,int sk,int f,int lc) {
	source=s;
	sink = sk;
	int tt=0,cur;
	if(!f)  return 0;
	while(f && PFS(s,sk)) {
		cur=f;
		if (f > lc) {
			cur = lc;
		}
		f-=cur;
		tt+=cur*dis[sk];
		if (!f) {
			return tt;
		}
		MakeResidal(sk);
	}

	return (-1);
}

int main() {
	int n, //nodes
	    m, //edges
	    i, //iterator
	    u,
	    v,
	    w, //loading weight, storing result
	    f = 2, //flow amount
	    lc = 1; //link capacity

	for(;;) {
		cin >> n;

		if (n == 0) {
			break;
		}

		cin >> m;

		for(i = 1; i <= n; i++)
			adj[i].clear();

		memset(cap,0,sizeof cap);
		memset(cst,0,sizeof cst);

		while(m--) {
			cin>>u>>v>>w;
			cst[u][v]=cst[v][u]=w;
			cap[u][v]=cap[v][u]=1;
			adj[u].push_back(v);
			adj[v].push_back(u);
		}

		//cin>>f>>lc;

		w = MinCostFlow(1,n,f,lc);

		if (w == -1)
			cout << "Back to jail" << endl;
		else
			cout << w << endl;
	}

	return (0);
}

