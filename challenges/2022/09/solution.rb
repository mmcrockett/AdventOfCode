# frozen_string_literal: true

class Numeric
  def limited(v)
    if abs > v
      return -v if negative?

      return v
    end

    self
  end
end

module Year2022
  class Day09 < Solution
    def d(v0, v1)
      dx = v0.first - v1.first
      dy = v0.last - v1.last

      [dx, dy, Math.sqrt(dx**2 + dy**2) >= 2]
    end

    def pgrid(hd, td)
      puts ''
      (0..4).reverse_each do |y|
        (0..5).each do |x|
          if hd.first == x && hd.last == y
            print('H')
          elsif td.first == x && td.last == y
            print('T')
          else
            print('.')
          end
        end

        puts ''
      end
    end

    def part_1
      h = [0, 0]
      t = [0, 0]
      r = {}
      r["#{t.join('_')}"] = true

      data.each do |direction, value|
        value.to_i.times do
          case direction
          when 'U'
            h[1] += 1
          when 'D'
            h[1] -= 1
          when 'L'
            h[0] -= 1
          when 'R'
            h[0] += 1
          end

          (dx, dy, too_far) = d(h, t)

          if too_far
            t[0] += dx.limited(1)
            t[1] += dy.limited(1)
          end

          r["#{t.join('_')}"] = true

          pgrid(h, t) if @debug
        end
      end

      r.size
    end

    def part_2
      rope = Array.new(10) { [0, 0] }
      r = {}
      r["#{rope.last.join('_')}"] = true

      data.each do |direction, value|
        value.to_i.times do
          case direction
          when 'U'
            rope[0][1] += 1
          when 'D'
            rope[0][1] -= 1
          when 'L'
            rope[0][0] -= 1
          when 'R'
            rope[0][0] += 1
          end

          rope.each_cons(2) do |a, b|
            (dx, dy, too_far) = d(a, b)

            if too_far
              b[0] += dx.limited(1)
              b[1] += dy.limited(1)
            end
          end

          r["#{rope.last.join('_')}"] = true
        end
      end

      r.size
    end

    private

    # Processes each line of the input file and stores the result in the dataset
    def process_input(line)
      line.split
    end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
