class Edge
  attr_reader :value

  alias :weight :value

  def initialize(node_a: nil, node_b: nil, value: nil, weight: nil, to: nil, from: nil)
    @node_a = node_a || to
    @node_b = node_b || from
    @value  = value || weight
  end

  def to
    @node_a
  end

  def from
    @node_b
  end

  def include?(node)
    vertices.include?(node)
  end

  def to_s
    vertices.join(" <#{value}> ")
  end

  def connected_to(node)
    result = vertices.reject {|other| other == node }

    raise "Not found in #{vertices.map(&:name)}" unless 1 == result.size

    result.last
  end

  def vertices
    [@node_a, @node_b]
  end
end
