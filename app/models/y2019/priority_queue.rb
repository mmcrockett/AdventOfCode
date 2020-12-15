module Dijkstra
  class PriorityQueue
    def initialize
      @queue = {}
    end

    def any?
      @queue.any?
    end

    def [](key)
      @queue[key]
    end

    def []=(key, value)
      @queue[key] = value
      order_queue
    end

    def remove_min
      @queue.shift.first
    end

    def size
      @queue.size
    end

    def to_s
      @queue.map {|k,v| [k.to_s, v]}
    end

    private
    def order_queue
      @queue = Hash[@queue.sort_by {|_key, value| value }]
    end

    alias_method :pop, :remove_min
  end
end
