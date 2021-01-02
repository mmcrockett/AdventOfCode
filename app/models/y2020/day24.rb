module Y2020
  class Day24
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext)).map do |line|
        values = line.chars
        result = []

        while false == values.empty?
          v = values.shift

          case v
          when 's', 'n'
            result << "#{v}#{values.shift}"
          else
            result << v
          end
        end

        result
      end
    end

    def grid
      grid = {}

      @data.each do |line|
        x = 0
        y = 0

        line.each do |direction|
          case direction
          when 'nw'
            y -= 1
            x -= 1
          when 'sw'
            y += 1
            x -= 1
          when 'ne'
            y -= 1
            x += 1
          when 'se'
            y += 1
            x += 1
          when 'e'
            x += 2
          when 'w'
            x -= 2
          else
            raise "Unknown '#{direction}'"
          end
        end

        case grid[[y, x]]
        when 'b'
          grid[[y, x]] = 'w'
        when nil, 'w'
          grid[[y, x]] = 'b'
        else
          raise "Unknown grid value '#{grid[[y, x]]}'"
        end
      end

      grid
    end

    def display(grid)
      min_y = grid.each_key.map(&:first).min - 1
      max_y = grid.each_key.map(&:first).max + 1
      min_x = grid.each_key.map(&:last).min
      max_x = grid.each_key.map(&:last).max + 1

      even_row_min = grid.find {|k,v| k.last == min_x }.first.first.even?

      min_x -= 1

      (min_y..max_y).each do |y|
        (min_x..max_x).each_with_index do |x, j|
          if (even_row_min != y.even? && j.odd?) || (even_row_min == y.even? && j.even?)
            print '-'
          else
            print grid[[y, x]] || 'w'
          end
        end

        puts
      end

      [[min_y, min_x], [max_y, max_x]]
    end

    def part1
      grid.select {|k,v| v == 'b' }.size
    end

    def part2(days: 100)
      adj = [[-1, -1], [1, -1], [-1, 1], [1, 1], [0, 2], [0, -2]].freeze
      grids = [grid]

      days.times do
        next_grid = {}
        last_grid = grids.last

        last_grid.select {|k,v| 'b' == v }.each do |coord, tile|
          black_friends = 0

          (y, x) = coord

          adj.each do |y_i, x_i|
            adj_coord = [y + y_i, x + x_i]

            if 'b' == last_grid[adj_coord]
              black_friends += 1
            else
              next_grid[adj_coord] ||= 0
              next_grid[adj_coord]  += 1
            end
          end

          next_grid[[y, x]] = 'b' if [1, 2].include?(black_friends)
        end

        grids << Hash[next_grid.select {|k,v| 'b' == v || 2 == v }.map {|k,v| [k, 'b'] }]
      end

      grids.last
    end
  end
end
