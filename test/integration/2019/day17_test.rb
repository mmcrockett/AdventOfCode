require 'test_helper'

class Day17Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"
  let(:p) {
    ->(d) {
      if (d.first.is_a?(Array))
        d.size.times do |y|
          puts ''

          d[y].size.times do |x|
            print d[y][x]&.chr || '.'
          end
        end
      else
        d.each do |c|
          print c.chr
        end
      end
    }
  }
  let(:p1_answer) {
    ElfComputer.new([], input_data).run.output
  }
  let(:p1_map) {
    map = []
    x = 0
    y = 0

    p1_answer.each do |v|
      if (v.scaffold?)
        map[y]  ||= []
        map[y][x] = v
      end

      if (v == 10)
        y += 1
        x  = 0
      else
        x += 1
      end
    end

    map
  }

  describe 'part 1' do
    before do
      @debug = false
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        sum = 0

        p.call(p1_answer) if true == @debug

        p1_map.size.times do |yi|
          p1_map[yi].size.times do |xi|
            next if p1_map[yi][xi].nil?
            next if (xi - 1) < 0 || (xi + 1) >= p1_map[yi].size || (yi - 1) < 0 || (yi + 1) >= p1_map.size
            next if p1_map[yi][xi - 1].nil? || p1_map[yi][xi + 1].nil? || p1_map[yi + 1][xi].nil? || p1_map[yi - 1][xi].nil?

            sum += yi * xi
          end
        end

        assert_equal(5068, sum)
      end
    end
  end

  describe 'part 2' do
    let(:data) { puzzle.dup }
    let(:modified) { z = input_data.dup; z[0] = 2; z }
    let(:is_corner) {
      -> (map, x, y) {
        if map[y][x].nil?
          false
        else
          left  = (x - 1) >= 0 && map[y][x - 1].present?
          right = (x + 1) < map[y].size && map[y][x + 1].present?
          up    = (y - 1) >= 0 && map[y - 1][x].present?
          down  = (y + 1) < map.size && map[y + 1][x].present?

          true != ((left && right) || (up && down))
        end
      }
    }
    let(:program) {
      <<-STR
      A,B,A,A,B,C,B,C,C,B
      L,12,R,8,L,6,R,8,L,6
      R,8,L,12,L,12,R,8
      L,6,R,6,L,12
      n
      STR
    }

    describe 'solution' do
      before do
        @debug = false
      end

      it 'analyzes' do
        skip if 5 == program.lines.size
        size    = p1_answer.find_index {|c| "\n" == c.chr } + 1
        robot   = '^'
        robot_i = p1_answer.find_index {|c| robot == c.chr }

        route = [
          ['L', 0]
        ]

        robot = '<'
        done  = false

        while false == done
          if '<' == robot
            if p1_answer[robot_i - 1]&.scaffold?
              robot_i -= 1
              route.last[-1] += 1
            elsif p1_answer[robot_i + size]&.scaffold?
              route << ['L', 0]
              robot = 'v'
            elsif p1_answer[robot_i - size]&.scaffold?
              route << ['R', 0]
              robot = '^'
            else
              done = true
            end
          elsif '>' == robot
            if p1_answer[robot_i + 1]&.scaffold?
              robot_i += 1
              route.last[-1] += 1
            elsif p1_answer[robot_i + size]&.scaffold?
              route << ['R', 0]
              robot = 'v'
            elsif p1_answer[robot_i - size]&.scaffold?
              route << ['L', 0]
              robot = '^'
            else
              done = true
            end
          elsif 'v' == robot
            if p1_answer[robot_i + size]&.scaffold?
              robot_i += size
              route.last[-1] += 1
            elsif p1_answer[robot_i + 1]&.scaffold?
              route << ['L', 0]
              robot = '>'
            elsif p1_answer[robot_i - 1]&.scaffold?
              route << ['R', 0]
              robot = '<'
            else
              done = true
            end
          elsif '^' == robot
            if p1_answer[robot_i - size]&.scaffold?
              robot_i -= size
              route.last[-1] += 1
            elsif p1_answer[robot_i + 1]&.scaffold?
              route << ['R', 0]
              robot = '>'
            elsif p1_answer[robot_i - 1]&.scaffold?
              route << ['L', 0]
              robot = '<'
            else
              done = true
            end
          else
            raise "Unknown dir '#{robot}'."
          end
        end

        route.each do |r|
          puts "#{r}"
        end
      end

      it 'works' do
        skip unless 5 == program.lines.size

        p.call(p1_map) if true == @debug

        answer = ElfComputer.new(program.gsub(' ', '').bytes, modified).run.output
        assert_equal(1415975, answer.last)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(',').map(&:to_i) }
end
