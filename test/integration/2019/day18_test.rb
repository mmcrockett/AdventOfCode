require 'test_helper'

class Day18Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"
  DOOR_TO_KEY = ('a'.ord - 'A'.ord).freeze

  def parse_map
    @entrances = {}
    @keys      = {}

    @input_data.each_with_index do |line, y|
      line.each_with_index do |tile, x|
        @entrances[tile + @entrances.size] = [x, y] if tile.entrance?
        @keys[tile]      = [x, y] if tile.vault_key?
      end
    end
  end

  def breadth_first_search
    @k2k       = {}
    @keys.merge(@entrances).each do |key, key_pos|
      queue = [ [*key_pos, []] ]
      distance = { key_pos => 0 }
      keys = []

      while(false == queue.empty?)
        from_x, from_y, needed_keys = queue.shift
        [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |delta_x, delta_y|
          x = from_x + delta_x
          y = from_y + delta_y
          pos  = [x,y]
          tile = @input_data[y][x]

          next if tile.wall? || distance.include?(pos)

          distance[pos] = distance[[from_x,from_y]] + 1

          keys << [ tile, needed_keys, distance[pos] ] if tile.vault_key?

          if tile.vault_door?
            queue << [x, y, needed_keys + [tile + DOOR_TO_KEY]]
          else
            queue << [x, y, needed_keys]
          end
        end
      end

      @k2k[key] = keys
    end
  end

  def reachable_keys(pos, unlocked = [])
    keys = []

    pos.each_with_index do |from_key, runner|
      @k2k[from_key].each do |key, needed_keys, distance|
        next if unlocked.include?(key)
        next unless (needed_keys - unlocked).empty?
        keys << [ runner, key, distance ]
      end
    end

    return keys
  end

  def min_steps(pos, unlocked = [], cache = {})
    cache_key = [pos.sort.join, unlocked.sort.join]

    if false == cache.include?(cache_key)
      keys = reachable_keys(pos, unlocked)
      if keys.empty?
        val = 0
      else
        steps = []
        keys.each do |runner, key, distance|
          orig = pos[runner]
          pos[runner] = key
          steps << distance + min_steps(pos, unlocked + [key], cache)
          pos[runner] = orig
        end
        val = steps.min
      end
      cache[cache_key] = val
    end

    return cache[cache_key]
  end

  describe 'part 1' do
    before do
      @input_data = input_data
      parse_map
      breadth_first_search
      @answer = min_steps(@entrances.keys)
    end

    describe 'example 0' do
      let(:data) { p1_e0 }

      it 'works' do
        assert_equal(8, @answer)
      end
    end

    describe 'example 1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal(86, @answer)
      end
    end

    describe 'example 2' do
      let(:data) { p1_e2 }

      it 'works' do
        assert_equal(136, @answer)
      end
    end

    describe 'example 3' do
      let(:data) { p1_e3 }

      it 'works' do
        assert_equal(81, @answer)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(3146, @answer)
      end
    end
  end

  describe 'part 2' do
    before do
      @input_data = input_data
      parse_map

      (x0, y0) = @entrances.values.first

      @input_data[y0][x0] = '#'.ord
      @input_data[y0 + 1][x0] = '#'.ord
      @input_data[y0 - 1][x0] = '#'.ord
      @input_data[y0][x0 + 1] = '#'.ord
      @input_data[y0][x0 - 1] = '#'.ord
      @input_data[y0 + 1][x0 + 1] = '@'.ord
      @input_data[y0 - 1][x0 - 1] = '@'.ord
      @input_data[y0 + 1][x0 - 1] = '@'.ord
      @input_data[y0 - 1][x0 + 1] = '@'.ord

      parse_map

      breadth_first_search
      @answer = min_steps(@entrances.keys)
    end

    describe 'example 3' do
      let(:data) { p2_e3 }

      it 'works' do
        assert_equal(72, @answer)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(2194, @answer)
      end
    end
  end

  let(:p1_e0) {
    <<-STR
    #########
    #b.A.@.a#
    #########
    STR
  }
  let(:p1_e1) {
    <<-STR
    ########################
    #f.D.E.e.C.b.A.@.a.B.c.#
    ######################.#
    #d.....................#
    ########################
    STR
  }
  let(:p1_e2) {
    <<-STR
    #################
    #i.G..c...e..H.p#
    ########.########
    #j.A..b...f..D.o#
    ########@########
    #k.E..a...g..B.n#
    ########.########
    #l.F..d...h..C.m#
    #################
    STR
  }
  let(:p1_e3) {
    <<-STR
    ########################
    #@..............ac.GI.b#
    ###d#e#f################
    ###A#B#C################
    ###g#h#i################
    ########################
    STR
  }
  let(:p2_e3) {
    <<-STR
    #############
    #g#f.D#..h#l#
    #F###e#E###.#
    #dCba...BcIJ#
    #####.@.#####
    #nK.L...G...#
    #M###N#H###.#
    #o#m..#i#jk.#
    #############
    STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.lines.map {|line| line.strip.chomp.chars.map(&:ord) } }
end
