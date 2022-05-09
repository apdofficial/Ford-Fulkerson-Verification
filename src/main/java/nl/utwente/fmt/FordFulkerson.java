package nl.utwente.fmt;

import java.util.Arrays;
import java.util.LinkedList;

class FordFulkerson {
    static final int V = 6;

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
    boolean hasAugmentingPath(int[][] graph, int s, int t, int[] p) {
        boolean[] visited = new boolean[V];
        // mark all the vertices as not visited
        for (int i = 0; i < V; ++i)
            visited[i] = false;
        LinkedList<Integer> queue = new LinkedList<>();
        queue.add(s);
        visited[s] = true;
        p[s] = -1;
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
     * Compute maximum flow from the given graph.
     * Edmonds Karp variant of the Ford Fulkerson algorithm
     * @param graph used for computing max flow.
     * @param s source
     * @param t sink
     * @return maximum flow of the network
     */
    int get_max_flow(int[][] graph, int s, int t) {
        int[][] residualNetwork =  Arrays.copyOf(graph, graph.length);
        // augmenting path
        int[] p = new int[V];
        int maxFlow = 0;
        // bottleneck vertex
        int u;
        // Augment the flow while there is path from source to sink
        while (hasAugmentingPath(residualNetwork, s, t, p)) {
            // Find minimum residual capacity of the edges along the
            // path filled by BFS. Or we can say find the maximum flow
            // through the path found.
            int bottleneckPathFlow = Integer.MAX_VALUE;
            for (int v = t; v != s; v = p[v]) {
                u = p[v];
                bottleneckPathFlow = Math.min(bottleneckPathFlow, residualNetwork[u][v]);
            }
            // update residual capacities of the edges and reverse edges
            // along the path
            for (int v = t; v != s; v = p[v]) {
                u = p[v];
                residualNetwork[u][v] -= bottleneckPathFlow;
                residualNetwork[v][u] += bottleneckPathFlow;
            }
            // Adding the path flow
            maxFlow += bottleneckPathFlow;
        }
        return maxFlow;
    }

    public static void printNetwork(int[][] network){
        for (int u = 0; u < network.length; u++) {
            for (int v = 0; v < network.length; v++) {
                if (network[u][v] > 0) {
                    System.out.println(u + " -> " + v + ": " + network[u][v]);
                }
            }
            System.out.println("");
        }
    }

    public static void main(String[] args) {
        // graph with the capacities
        int[][] graph = new int[][]{{0, 3, 2, 0, 0, 0},
                                    {0, 0, 0, 2, 0, 0},
                                    {0, 3, 0, 0, 3, 0},
                                    {0, 0, 1, 0, 0, 3},
                                    {0, 0, 0, 3, 0, 2},
                                    {0, 0, 0, 0, 0, 0}};
        printNetwork(graph);
        FordFulkerson m = new FordFulkerson();
        System.out.println("Max Flow: " + m.get_max_flow(graph, 0, 5));
    }
}

