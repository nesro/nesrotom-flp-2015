#include <iostream>
#include <vector>
#include <algorithm>
#include <limits>
#include <queue>
#include <utility>
#include <set>

#define DEBUG 1

/* vector of nodes, containing a vector of pairs <node, weight> */
typedef std::vector<std::vector<std::pair<int,int> > > graph_t;

class priority_queue_comparator {
public:
	int operator() (const std::pair<int,int> &a,
	    const std::pair<int,int> &b) { return (a.second > b.second); }};

/* Dijkstra's algorithm
 * http://en.wikipedia.org/wiki/Dtra's_algorithm
 * returning pair of vector of distances with vector of parents */
std::pair<std::vector<int>,std::vector<int> >
dijkstra(graph_t &graph, int node_from, int node_to)
{
	std::vector<int> prev(graph.size(), -1);
	std::vector<int> dist(graph.size(), std::numeric_limits<int>::max());
	std::priority_queue<std::pair<int,int>,
	    std::vector<std::pair<int,int> >, priority_queue_comparator> queue;
	std::vector<std::pair<int,int> > visited_edges;

	dist[node_from] = 0;
	queue.push(std::make_pair(node_from, dist[node_from]));

	while (!queue.empty()) {
		int node;

		node = queue.top().first;
		if (node == node_to) {
			break;
		}
		queue.pop();
		for (unsigned int i = 0; i < graph[node].size(); i++) {
			int edge_node = graph[node][i].first;
			int edge_dist = graph[node][i].second;
			int alt_dist = dist[node] + edge_dist;
			if (alt_dist < dist[edge_node]) {
				dist[edge_node] = alt_dist;
				prev[edge_node] = node;
				queue.push(std::make_pair(edge_node,
				    dist[edge_node]));
			}
		}
	}

	/*
	int p = node_to;
	int p2 = pred[p];
	while (p != node_from) {
		if (DEBUG)
			std::cout << "adding edge: " << p << " " << p2 <<
			    std::endl;
		visited_edges.push_back(std::make_pair(p, p2));

		p = p2;
		p2 = pred[p2];
	}
	*/

	return (std::make_pair(dist, prev));
}


/* http://en.wikipedia.org/wiki/Suurballe's_algorithm */
void
suurballe(graph_t &graph, int node_from, int node_to)
{
	std::pair<std::vector<int>, std::vector<int> > dijkstra_tree;
	std::vector<int> shortest_path;
	int tmp_node;

	dijkstra_tree = dijkstra(graph, node_from, node_to);

	/* reconstruct the shortest path */
	tmp_node = node_to;
	while (tmp_node != node_from) {
		shortest_path.push_back(tmp_node);
		tmp_node = dijkstra_tree.second[tmp_node];
	}
	shortest_path.push_back(tmp_node);

	/* TODO */

}

int
main(void) {
	for (;;) {
		graph_t graph;
		int nodes;
		int edges;

		std::cin >> nodes;

		if (nodes == 0) {
			break;
		}

		graph.resize(nodes);
		std::cin >> edges;

		for (int i = 0; i < edges; i++) {
			int edge_from;
			int edge_to;
			int edge_weight;

			std::cin >> edge_from;
			std::cin >> edge_to;
			std::cin >> edge_weight;

			edge_from--;
			edge_to--;

			graph[edge_from].push_back(std::make_pair(edge_to,
			    edge_weight));
			graph[edge_to].push_back(std::make_pair(edge_from,
			    edge_weight));
		}

		suurballe(graph, 0, nodes - 1);
	}

	return (EXIT_SUCCESS);
}

