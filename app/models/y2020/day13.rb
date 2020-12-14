module Y2020
  class Day13
    include FileName

    def initialize(file: nil, file_ext: nil, preamble_size: 25)
      @data = load_data(file_name(file: file, file_ext: file_ext))
      @ready_time = @data[0].to_i
      @schedules  = @data[1].split(',').map {|v| v.to_d }
    end

    def part1
      min = BigDecimal::INFINITY
      ans = nil

      @schedules.select {|v| v.positive? }.each do |t|
        delta = (@ready_time / t).ceil * t - @ready_time

        if delta < min
          min = delta
          ans = t
        end
      end

      ans.to_i * min.to_i
    end

    def self.first_match(a, b)
      i = a.value - a.offset

      while true
        return i if ((i + b.offset) % b.value).zero?

        i += a.value
      end
    end

    def self.combine(a, b)
      match = Day13.first_match(a, b)

      OpenStruct.new(
        value: a.value * b.value,
        offset: match * -1
      )
    end

    def part2
      buses = @schedules.map.each_with_index do |v, i|
        next unless v.positive?

        OpenStruct.new(value: v, offset: i)
      end.compact

      current_bus = buses.shift

      while false == buses.empty?
        current_bus = Day13.combine(current_bus, buses.shift)
      end

      current_bus.offset * -1
    end
  end
end
