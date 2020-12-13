class Day9
  # 464 high
  include FileName

  def initialize(file: nil, file_ext: nil)
    @raw_data = load_data(file_name(file: file, file_ext: file_ext)).map {|v| parse(v) }
  end

  def parse(line)
    (a, _z, b, _y, d) = line.split(/(to|=)/)
    OpenStruct.new(
      a: a.strip,
      b: b.strip,
      d: d.to_i
    )
  end

  def part1
    cities = {}
    connections = []
    min_value = BigDecimal::INFINITY

    @raw_data.each do |data|
      [data.a, data.b].each {|name| cities[name] ||= Node.new(name) }

      connections << Edge.new(from: cities[data.a], to: cities[data.b], value: data.d)
    end

    cities.values.permutation.map do |order|
      distance = (1..order.size - 1).map do |j|
        city_a = order[j - 1]
        city_b = order[j]

        found_edge = connections.find {|edge| edge.include?(city_a) && edge.include?(city_b) }

        found_edge.nil? ? BigDecimal::INFINITY : found_edge.weight
      end.sum
    end.min
  end

  def part2
    cities = {}
    connections = []
    min_value = BigDecimal::INFINITY

    @raw_data.each do |data|
      [data.a, data.b].each {|name| cities[name] ||= Node.new(name) }

      connections << Edge.new(from: cities[data.a], to: cities[data.b], value: data.d)
    end

    cities.values.permutation.map do |order|
      distance = (1..order.size - 1).map do |j|
        city_a = order[j - 1]
        city_b = order[j]

        found_edge = connections.find {|edge| edge.include?(city_a) && edge.include?(city_b) }

        found_edge.nil? ? BigDecimal::INFINITY : found_edge.weight
      end.sum
    end.max
  end
end
