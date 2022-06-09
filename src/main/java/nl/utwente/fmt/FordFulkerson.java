package nl.utwente.fmt;

import java.util.LinkedList;

class FordFulkerson {

    /**
     * Check whether the given graph contains augmented path from source to sink.
     *
     * The search is performed using the Breath-First Search algorithm.
     * @param graph 2D array with capacities
     * @param s source
     * @param t sink
     * @param p augmented path
     * @return true if there is a path from source 's' to sink 't' in residual graph, false otherwise
     */
    boolean hasAugmentingPath(int[][] graph, int s, int t, int[] p, int V) {
        boolean[] visited = new boolean[V];
        // mark all the vertices as not visited
        for (int i = 0; i < V; ++i)
            visited[i] = false;
        LinkedList<Integer> queue = new LinkedList<>();

        queue.add(s);
        visited[s] = true;
        // Get all adjacent vertices of the dequeued vertex u
        // If an adjacent has not been visited, then mark it
        // visited and enqueue it
        while (!queue.isEmpty()) {
            int u = queue.poll();
            for (int v = 0; v < V; v++) {
                // if residual capacity from v to w
                if (!visited[v] && graph[u][v] > 0) {
                    queue.add(v);
                    p[v] = u;
                    visited[v] = true;
                }
            }
        }
        // If we reached sink in BFS starting from source, then return true, else false
        return visited[t];
    }

        /**
     * Compute maximum flow from the given G.
     * Edmonds Karp variant of the Ford Fulkerson algorithm
     * @param G used for computing max flow.
     * @param s source
     * @param t sink
     * @return maximum flow of the network
     */
    int get_max_flow(int[][] G, int s, int t, int V) {
        int[][] Gf = new int[V][V];

        for (int i = 0; i < V; i++)
            for (int j = 0; j < V; j++)
                Gf[i][j] = G[i][j];

        // augmenting path
        int[] p = new int[V];
        int maxFlow = 0;
        // bottleneck vertex
        int u;
        // Augment the flow while there is path from source to sink
        while (hasAugmentingPath(Gf, s, t, p, V)) {
            // Find minimum residual capacity of the edges along the
            // path filled by BFS. Or we can say find the maximum flow
            // through the path found.
            int bottleneckPathFlow = 999999999;
            for (int v = t; v != s; v = p[v]) {
                u = p[v];
                bottleneckPathFlow = (bottleneckPathFlow <= Gf[u][v]) ? bottleneckPathFlow : Gf[u][v];
            }
            // update residual capacities of the edges and reverse edges along the path
            for (int v = t; v != s; v = p[v]) {
                u = p[v];
                Gf[u][v] -= bottleneckPathFlow;
                Gf[v][u] += bottleneckPathFlow;
            }
            // Adding the path flow
            maxFlow += bottleneckPathFlow;
            printNetwork(Gf, "Gf", 6);
        }
        return maxFlow;
    }

    public static void printNetwork(int[][] network, String name, int V){
        System.out.println("Printing Network " + name);
        for (int u = 0; u < V; u++) {
            System.out.println("(" + u + ") ");
            for (int v = 0; v < V; v++) {
                if (network[u][v] > 0) {
                    System.out.println(" '--" + network[u][v] + "--> (" + v + ")");
                }
            }
        }
    }

    public static void main(String[] args) {
        // graph with the capacities
        int[][] G = new int[][]{{0, 3, 2, 0, 0, 0},
                                    {0, 0, 0, 2, 0, 0},
                                    {0, 3, 0, 0, 3, 0},
                                    {0, 0, 1, 0, 0, 3},
                                    {0, 0, 0, 3, 0, 2},
                                    {0, 0, 0, 0, 0, 0}};
        printNetwork(G, "G", 6);
        FordFulkerson m = new FordFulkerson();
        System.out.println("Max Flow: " + m.get_max_flow(G, 0, 5, 6));
    }
}