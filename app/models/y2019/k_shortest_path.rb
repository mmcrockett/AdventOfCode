module Dijkstra
  class KShortestPath
    def initialize(nodes, source, debug = false)
      @paths    = []
      @counts   = {}
      @pqueue   = PriorityQueue.new

      @pqueue[source] = 0

      nodes.each do |node|
        @counts[node] = 0
      end

      calculate_paths
    end

    def paths
      @prev
    end

    def shortest_path_to(node)
      path = []
      u = node

      if @prev[u]
        while u
          path << u
          u = @prev[u]
        end
      end

      path
    end

    def shortest_distance_to(node)
      @dist[node]
    end

    private
    def calculate_paths
      while @pqueue.any?
        u = @pqueue.pop

        puts "Processing '#{u.name}'" if @debug

        u.neighbors.each do |v|
          alt_d = @dist[u] + u.length(v)

          puts "\tNeighbor '#{v.name}' is '#{u.length(v)}' away for total distance of '#{alt_d}' vs '#{@dist[v]}'" if @debug

          if alt_d < @dist[v]
            @dist[v] = alt_d
            @prev[v] = u
            @pqueue[v] = alt_d
            puts "\t\tNew distance to #{v.name}, closest to #{v.name} is #{u.name} priority is now #{@pqueue[v]}" if @debug
          end
        end
      end

      return @dist, @prev
    end
  end
end
