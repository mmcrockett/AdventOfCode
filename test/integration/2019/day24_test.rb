require 'test_helper'

class Day24Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  let(:directions) { ([1, 0].permutation.to_a + [-1, 0].permutation.to_a).freeze }
  let(:biodiversity) {
    ->(grid) {
      answer = 0
      l      = grid.size.freeze

      l.times do |y|
        l.times do |x|
          answer += (1 << y * l + x) if grid[y][x].bug?
        end
      end

      answer
    }
  }
  let(:print_grid) {
    ->(grid, recursive = false) {
      l = grid.size.freeze

      l.times do |y|
        puts ''
        l.times do |x|
          if (true == recursive) && ([mp, mp] == [y, x])
            print '?'
            raise 'bad mp' if grid[y][x] != '.'.ord
          else
            print grid[y][x].chr
          end
        end
      end

      puts ''
    }
  }

  describe 'part 1' do
    let(:life) {
      ->(grid) {
        new_grid = []
        l = grid.size.freeze

        l.times do |y|
          new_grid[y] ||= []

          l.times do |x|
            adj_bugs = directions.map do |dx, dy|
              _x = dx + x
              _y = dy + y
              1 if (_y >= 0) && (_x >= 0) && (_y < l) && (_x < l) && grid[_y][_x].bug?
            end

            adj_bugs = adj_bugs.map(&:to_i).sum

            if 1 == adj_bugs || (2 == adj_bugs && grid[y][x].opening?)
              new_grid[y][x] = '#'.ord
            else
              new_grid[y][x] = '.'.ord
            end
          end
        end

        new_grid
      }
    }

    describe 'biodiversity' do
      let(:data) { p1_e0_answer }

      it 'works' do
        assert_equal(2129920, biodiversity.call(input_data))
      end
    end

    describe 'example' do
      let(:data) { p1_e0 }

      it 'works' do
        cmap    = input_data
        biod    = biodiversity.call(cmap)
        found   = {}

        while found[biod].nil?
          found[biod] = true
          cmap = life.call(cmap)
          biod = biodiversity.call(cmap)
        end

        assert_equal(2129920, biod)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        cmap    = input_data
        biod    = biodiversity.call(cmap)
        found   = {}

        while found[biod].nil?
          found[biod] = true
          cmap = life.call(cmap)
          biod = biodiversity.call(cmap)
        end

        assert_equal(18407158, biod)
      end
    end
  end

  describe 'part 2' do
    let(:life) {
      ->(grids) {
        new_grids = []

        grids.each_with_index do |grid, z|
          new_grid = []

          l.times do |y|
            new_grid[y] ||= []

            l.times do |x|
              adj_bug_count = adj_bugs.call(x, y, z, grids)

              if 1 == adj_bug_count || (2 == adj_bug_count && grid[y][x].opening?)
                new_grid[y][x] = '#'.ord
              else
                new_grid[y][x] = '.'.ord
              end
            end
          end

          new_grids << new_grid
        end

        new_grids
      }
    }
    let(:adj_bugs) {
      ->(x, y, z, grids) {
        if mp != x || mp != y
          grid = grids[z]

          adj_bugs = directions.map do |dx, dy|
            #debugger if z == 0
            _x = dx + x
            _y = dy + y

            if (mp == _y) && (mp == _x)
              other_grid = grids[z - 1]

              if other_grid.present?
                if [mp, 1] == [x, y]
                  other_grid[0].map {|tile| 1 if tile.bug? }.map(&:to_i).sum
                elsif [mp, 3] == [x, y]
                  other_grid[-1].map {|tile| 1 if tile.bug? }.map(&:to_i).sum
                elsif [1, mp] == [x, y]
                  other_grid.map {|row| 1 if row[0].bug? }.map(&:to_i).sum
                elsif [3, mp] == [x, y]
                  other_grid.map {|row| 1 if row[-1].bug? }.map(&:to_i).sum
                else
                  raise 'bad logic 1'
                end
              end
            elsif (_y < 0) || (_x < 0) || (_y >= l) || (_x >= l)
              other_grid = grids[z + 1]

              if other_grid.present?
                bugs = []

                if 0 > _y
                  bugs << 1 if other_grid[1][mp].bug?
                elsif _y >= l
                  bugs << 1 if other_grid[3][mp].bug?
                elsif 0 > _x
                  bugs << 1 if other_grid[mp][1].bug?
                elsif _x >= l
                  bugs << 1 if other_grid[mp][3].bug?
                else
                  raise 'bad logic 2'
                end

                bugs.sum
              end
            else
              1 if grid[_y][_x].bug?
            end
          end

          adj_bugs.map(&:to_i).sum
        else
          0
        end
      }
    }
    let(:blank_grid) {
      l.times.map { l.times.map { '.'.ord }}
    }
    let(:l) { input_data.size.freeze }
    let(:mp) { l / 2 }

    describe 'example' do
      let(:data) { p1_e0 }
      let(:ticks) { 10 }

      it 'works' do
        grids    = [input_data]
        found   = {}

        ticks.times do
          [:unshift, :push].each do |m|
            grids.send(m, blank_grid.dup)
          end

          grids = life.call(grids)
        end

        #grids.each_with_index {|grid, i| puts "= #{i} = "; print_grid.call(grid, true); }

        answer = grids.map {|grid| grid.map {|row| row.map {|tile| 1 if tile.bug? } } }.flatten.map(&:to_i).sum

        assert_equal(99, answer)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }
      let(:ticks) { 200 }

      it 'works' do
        grids    = [input_data]
        found   = {}

        ticks.times do
          [:unshift, :push].each do |m|
            grids.send(m, blank_grid.dup)
          end

          grids = life.call(grids)
        end

        answer = grids.map {|grid| grid.map {|row| row.map {|tile| 1 if tile.bug? } } }.flatten.map(&:to_i).sum

        assert_equal(1998, answer)
      end
    end
  end

  let(:p1_e0) {
    <<~STR
    ....#
    #..#.
    #..##
    ..#..
    #....
    STR
  }
  let(:p1_e0_answer) {
    <<~STR
    .....
    .....
    .....
    #....
    .#...
    STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.lines.map {|line| line.strip.chomp.chars.map(&:ord) } }
end
