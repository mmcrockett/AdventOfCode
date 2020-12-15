require 'test_helper'

class Day15Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  let(:ec) { ElfComputer.new([], input_data, loop_mode: true) }
  let(:directions) {
    {
      1 => [0,1],
      2 => [0,-1],
      3 => [-1,0],
      4 => [1,0]
    }
  }
  let(:output) {
    {
      0 => '#',
      1 => '.',
      2 => 'O'
    }
  }
  let(:start) { [50, 50] }
  let(:print_map) {
    ->(map, starting_x, ending_x, starting_y, ending_y) {
      (starting_y..ending_y).each do |y|
        puts ''

        (starting_x..ending_x).each do |x|
          print map[y][x] || '#'
        end
      end

      puts ''
    }
  }

  describe 'part 1' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        @debug = false
        robot  = ec.dup
        answer = nil
        map    = []
        (x, y) = start
        result = 1
        failsafe = 100000
        map[y]  ||= []
        map[y][x] = 'B'
        starting_y = y
        starting_x = x
        ending_y = y
        ending_x = x

        while answer.nil? && failsafe > 0
          next_i = directions.find {|k,v| map[y + v.last].nil? || map[y + v.last][x + v.first].nil?}

          if (next_i.nil?)
            next_i = directions.find {|k,v| false == [output[0], 'X'].include?(map[y + v.last][x + v.first])}
            map[y][x] = 'X'
          end

          debugger if next_i.nil?

          next_x = x + next_i.last.first
          next_y = y + next_i.last.last

          result = robot.run(next_i.first).output.first

          map[next_y] ||= []
          map[next_y][next_x] ||= output[result]
          #map[next_y][next_x] ||= 0

          if (0 != result)
            x = next_x
            y = next_y

            #map[next_y][next_x] += 1 unless [9, 'X'].include?(map[next_y][next_x])

            answer = [x,y] if result == 2
          end

          starting_x = x if starting_x > x
          starting_y = y if starting_y > y
          ending_x   = x if ending_x < x
          ending_y   = y if ending_y < y

          raise "Moving into negative #{x},#{y}" if 0 == x || 0 == y

          failsafe -= 1
        end

        starting_x -= 1
        starting_y -= 1
        ending_x   += 1
        ending_y   += 1

        print_map.call(map, starting_x, ending_x, starting_y, ending_y) if @debug

        (x, y)   = start
        answer_i = 0

        while ('O' != map[y][x])
          next_i = directions.find {|k,v| ['.', 'O'].include?(map[y + v.last][x + v.first])}
          map[y][x] = 'z'

          debugger if next_i.nil?

          x += next_i.last.first
          y += next_i.last.last

          answer_i += 1
        end

        assert(19970 > answer_i)
        assert(30 < answer_i)
        assert_equal(298, answer_i)
      end
    end
  end

  describe 'part 2' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        @debug = nil
        robot  = ec.dup
        answer = nil
        map    = []
        (x, y) = start
        result = 1
        failsafe = 100000
        map[y]  ||= []
        map[y][x] = 'B'
        starting_y = y
        starting_x = x
        ending_y = y
        ending_x = x

        while answer.nil? && failsafe > 0
          next_i = directions.find {|k,v| map[y + v.last].nil? || map[y + v.last][x + v.first].nil?}

          if (next_i.nil?)
            next_i = directions.find {|k,v| false == [output[0], 'X'].include?(map[y + v.last][x + v.first])}
            map[y][x] = 'X'
          end

          debugger if next_i.nil?

          next_x = x + next_i.last.first
          next_y = y + next_i.last.last

          result = robot.run(next_i.first).output.first

          map[next_y] ||= []
          map[next_y][next_x] ||= output[result]
          #map[next_y][next_x] ||= 0

          if (0 != result)
            x = next_x
            y = next_y

            #map[next_y][next_x] += 1 unless [9, 'X'].include?(map[next_y][next_x])

            answer = [x,y] if result == 2
          end

          starting_x = x if starting_x > x
          starting_y = y if starting_y > y
          ending_x   = x if ending_x < x
          ending_y   = y if ending_y < y

          raise "Moving into negative #{x},#{y}" if 0 == x || 0 == y

          failsafe -= 1
        end

        starting_x -= 1
        starting_y -= 1
        ending_x   += 1
        ending_y   += 1

        print_map.call(map, starting_x, ending_x, starting_y, ending_y) if @debug

        t = 0
        oxygen = {
          t => [answer]
        }

        while false == oxygen[t].empty?
          next_t = t + 1

          oxygen[next_t] ||= []

          oxygen[t].each do |x,y|
            map[y][x] = 'o'

            directions.select {|k,v| false == ['#', nil, 'o'].include?(map[y + v.last][x + v.first])}.map {|k,v| [x + v.first, y + v.last] }.each do |next_oxygen|
              oxygen[next_t] << next_oxygen
            end
          end

          print_map.call(map, starting_x, ending_x, starting_y, ending_y) if 0 == (t % 20) && true == @debug

          t = next_t
        end

        t -= 1

        assert(347 > t)
        assert_equal(346, t)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(',').map(&:to_i) }
end
