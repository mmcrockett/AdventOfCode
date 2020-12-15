require 'test_helper'

class Day6Test < ActiveSupport::TestCase
  let(:example) {
    res = <<-STR
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
    STR
  }
  let(:example2) {
    res = <<-STR
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
      K)YOU
      I)SAN
    STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', 'day6_input.txt')) }
  let(:input_data) { data.lines.map {|line| line.chomp.strip.split(')') } }
  let(:solution0) {
    relationships = {}
    current_key   = 'COM'

    input_data.each do |orbitee, orbiter|
      relationships[orbitee] ||= []
      relationships[orbitee] << orbiter
    end

    distance(relationships, current_key, 0)
  }
  let(:solution1) {
    relationships = {}
    current_key   = 'COM'
    paths         = []

    input_data.each do |orbitee, orbiter|
      relationships[orbiter] = orbitee
    end

    ['SAN', 'YOU'].each do |person|
      paths << []

      orbitee = relationships[person]

      while ('COM' != orbitee)
        paths.last << orbitee

        orbitee = relationships[orbitee]
      end
    end

    diverge_loc = paths.first.find {|sloc| paths.last.include?(sloc)}

    paths.first.find_index {|sloc| diverge_loc == sloc } + paths.last.find_index {|mloc| diverge_loc == mloc }
  }

  def distance(d, k, dist)
    orbits = d[k]

    if orbits.blank?
      return dist
    else
      return dist + orbits.map {|v| distance(d, v, dist + 1) }.inject(&:+)
    end
  end

  describe 'part 1' do
    describe 'example' do
      let(:data) { example }

      it 'works' do
        assert_equal(42, solution0)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(273985, solution0)
      end
    end
  end

  describe 'part 2' do
    describe 'example' do
      let(:data) { example2 }

      it 'works' do
        assert_equal(4, solution1)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(460, solution1)
      end
    end
  end
end
