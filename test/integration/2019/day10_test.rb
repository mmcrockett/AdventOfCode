require 'test_helper'

class Day10Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  let(:as_coords) {
    results = []

    input_data.each_with_index do |line, y|
      line.each_with_index do |v, x|
        results << [x,y] if true == v
      end
    end

    results
  }

  describe 'helpers' do
    it 'can create a line' do
      line0 = [0,0].create_line([2,4])
      line1 = [2,4].create_line([0,0])

      [line0, line1].each do |line|
        assert(line.colinear?([4, 8]))
        assert(line.colinear?([2, 4]))
        assert(line.colinear?([0, 0]))

        assert_not(line.colinear?([0, 4]))
      end
    end

    it 'works for horizontal' do
      line = [5,0].create_line([8,0])

      assert(line.colinear?([5, 0]))
      assert(line.colinear?([9, 0]))

      assert_not(line.colinear?([6, 2]))
    end

    it 'works for vertical' do
      line = [0,1].create_line([0,4])

      assert(line.colinear?([0, -1]))
      assert(line.colinear?([0, 3]))

      assert_not(line.colinear?([1, 4]))
    end

    it 'has covector' do
      line = [1,2].create_line([4,5])

      assert(line.colinear?([7, 8]))
      assert(line.covector?([7, 8]))
      assert(line.colinear?([-2, -1]))
      assert_not(line.covector?([-2, -1]))
    end
  end

  describe 'p1' do
    let(:code) {
      max = 0
      answers = {}

      as_coords.each do |coord|
        others  = as_coords.reject {|c| c == coord }.sort_by {|c| coord.md(c) }
        visible = []

        while (false == others.empty?)
          a = others.shift
          line = coord.create_line(a)

          removed = others.select {|c| line.covector?(c) }
          others -= removed

          puts "#{a}:#{removed}" if false == removed.empty? && @debug == coord

          visible << a
        end

        max = visible.size if visible.size > max
        answers[visible.size] = coord
      end

      [max, answers[max]]
    }

    describe 'e0' do
      let(:data) { p1_e0 }

      it 'works' do
        assert_equal(8, code.first)
      end
    end

    describe 'e1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal(33, code.first)
      end
    end

    describe 'e2' do
      let(:data) { p1_e2 }

      it 'works' do
        assert_equal(35, code.first)
      end
    end

    describe 'e3' do
      let(:data) { p1_e3 }

      it 'works' do
        assert_equal(41, code.first)
      end
    end

    describe 'e4' do
      let(:data) { p1_e4 }

      it 'works' do
        assert_equal(210, code.first)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(286, code.first)
        assert_equal([22, 25], code.last)
      end
    end
  end

  describe 'part 2' do
    let(:code) {
      max = 0
      groupings = {}
      destroyed = []
      ordered   = []
      coords    = as_coords
      coords.delete(laser)

      coords.each do |other|
        slope = laser.create_line(other).slope
        key   = nil

        if 0 == slope[:x]
          key = 0 if slope[:y].negative?
          key = 180 if slope[:y].positive?
          slope = 9999999
        elsif 0 == slope[:y]
          key = 90 if slope[:x].positive?
          key = 270 if slope[:x].negative?
          slope = 0
        else
          key = 45 if slope[:x].positive? && slope[:y].negative?
          key = 135 if slope[:x].positive? && slope[:y].positive?
          key = 225 if slope[:x].negative? && slope[:y].positive?
          key = 315 if slope[:x].negative? && slope[:y].negative?
        end

        groupings[key] ||= {}
        groupings[key][slope] ||= []
        groupings[key][slope] << other
      end

      groupings.keys.sort.each do |k0|
        subkeys = groupings[k0].keys if 0 == (k0 % 90)
        subkeys = groupings[k0].keys.sort_by {|slope| (slope[:y].to_f/slope[:x]).abs }.reverse if [45, 225].include?(k0)
        subkeys = groupings[k0].keys.sort_by {|slope| (slope[:x].to_f/slope[:y]).abs }.reverse if [135, 315].include?(k0)

        subkeys.each do |k1|
          ordered << groupings[k0][k1] 
        end
      end

      ordered.each {|sl| sl.sort_by! {|other| laser.md(other)}}

      while (destroyed.size < coords.size)
        ordered.each do |sight_line|
          destroyed << sight_line.shift if false == sight_line.empty?
        end
      end

      destroyed
    }

    describe 'e4' do
      let(:data) { p1_e4 }
      let(:laser) { [11, 13] }

      it 'works' do
        esize  = as_coords.size - 1
        answer = code
        assert_equal(esize, answer.size)
        assert_equal([11,12], answer[0])
        assert_equal([12,1], answer[1])
        assert_equal([12,2], answer[2])
        assert_equal([12,8], answer[9])
        assert_equal([16,0], answer[19])
        assert_equal([16,9], answer[49])
        assert_equal([10,16], answer[99])
        assert_equal([9,6], answer[198])
        assert_equal([8,2], answer[199])
        assert_equal([10,9], answer[200])
        assert_equal([11,1], answer.last)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }
      let(:laser) { [22, 25] }

      it 'works' do
        esize  = as_coords.size - 1
        answer = code
        assert_equal(esize, answer.size)
        assert_equal([5,4], answer[199])
      end
    end
  end

  let(:p1_e0) {
    <<-STR
    .#..#
    .....
    #####
    ....#
    ...##
    STR
  }
  let(:p1_e1) {
    <<-STR
    ......#.#.
    #..#.#....
    ..#######.
    .#.#.###..
    .#..#.....
    ..#....#.#
    #..#....#.
    .##.#..###
    ##...#..#.
    .#....####
    STR
  }
  let(:p1_e2) {
    <<-STR
    #.#...#.#.
    .###....#.
    .#....#...
    ##.#.#.#.#
    ....#.#.#.
    .##..###.#
    ..#...##..
    ..##....##
    ......#...
    .####.###.
    STR
  }
  let(:p1_e3) {
    <<-STR
    .#..#..###
    ####.###.#
    ....###.#.
    ..###.##.#
    ##.##.#.#.
    ....###..#
    ..#.#..#.#
    #..#.#.###
    .##...##.#
    .....#.#..
    STR
  }
  let(:p1_e4) {
    <<-STR
    .#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##
    STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.lines.map {|line| line.chomp.strip.chars.map {|c| c == '#'}} }
end
