module Y2020
  class Day18
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext))
    end

    def e(data)
      i     = 0
      total = data[0].to_i

      while i < data.size
        case data[i]
        when '*'
          total *= data[i + 1].to_i
          i     += 2
        when '+'
          total += data[i + 1].to_i
          i     += 2
        else
          i += 1
        end
      end

      total
    end

    def parse(str)
      results = {}
      depth   = 0

      str.delete(' ').chars.each do |v|
        case v
        when '('
          depth += 1
        when ')'
          v = e(results[depth])
          results.delete(depth)
          depth -= 1
        end

        results[depth] ||= []
        results[depth]  <<  v unless ['(', ')'].include?(v)
      end

      results.values.map do |values|
        e(values)
      end
    end

    def part1
      @data.map {|line| parse(line) }
    end

    def e_2(data)
      data = data.dup

      ['+', '*'].each do |operator|
        next_o = data.index(operator)

        while false == next_o.nil?
          s_i  = next_o - 1
          e_i  = next_o + 1
          slice_start = s_i - 1
          slice_end   = e_i + 1
          v    = data[s_i].to_i.send(operator, data[e_i].to_i)

          if data.size == 3
            data = [v]
          elsif slice_start.negative?
            data = [v] + data[slice_end..-1]
          elsif slice_end >= data.size
            data = data[0..slice_start] + [v]
          else
            data = data[0..slice_start] + [v] + data[slice_end..-1]
          end

          next_o = data.index(operator)
        end
      end

      data.last
    end

    def parse_part2(str)
      results = {}
      depth   = 0

      str.delete(' ').chars.each do |v|
        case v
        when '('
          depth += 1
        when ')'
          v = e_2(results[depth])
          results.delete(depth)
          depth -= 1
        end

        results[depth] ||= []
        results[depth]  <<  v unless ['(', ')'].include?(v)
      end

      results.values.map do |values|
        e_2(values)
      end
    end

    def part2
      @data.map {|line| parse_part2(line) }
    end
  end
end
