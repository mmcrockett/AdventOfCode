module Dijkstra
  class Node
    attr_accessor :name, :x, :y, :z

    def initialize(name, x: nil, y: nil, z: nil)
      @name = name
      @x    = x
      @y    = y
      @z    = z
      @neighbors = {}
    end

    def coord
      [x,y]
    end

    def neighbors
      @neighbors.keys
    end

    def length(node)
      @neighbors[node] || Float::INFINITY
    end

    def add_neighbor(node, d)
      @neighbors[node] = d

      return self
    end

    def to_s
      "#{@name}:[#{x},#{y}]"
    end
  end
end
