require 'test_helper'

class Day12Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  describe 'part 1' do
    let(:code) {
      positions  = input_data.dup
      n          = positions.size.freeze
      velocities = []

      n.times { velocities << [0,0,0] }

      max_steps.times do
        (0..n - 1).each do |i|
          (i + 1..n - 1).each do |j|
            3.times do |t|
              next if positions[i][t] == positions[j][t]

              if positions[i][t] > positions[j][t]
                velocities[i][t] -= 1
                velocities[j][t] += 1
              else
                velocities[i][t] += 1
                velocities[j][t] -= 1
              end
            end
          end

          positions[i] = positions[i].map.each_with_index {|p, k| p += velocities[i][k]}
        end
      end

      {
        p: positions,
        v: velocities,
        a: positions.map.each_with_index {|p, i| p.map(&:abs).sum * velocities[i].map(&:abs).sum}.sum
      }
    }

    describe 'e0' do
      let(:data) { p1_e0 }
      let(:max_steps) { 10 }

      it 'works' do
        assert_equal(179, code[:a])
      end
    end

    describe 'e1' do
      let(:data) { p1_e1 }
      let(:max_steps) { 100 }

      it 'works' do
        assert_equal(1940, code[:a])
      end
    end

    describe 'solution' do
      let(:data) { puzzle }
      let(:max_steps) { 1000 }

      it 'works' do
        assert_equal(10845, code[:a])
      end
    end
  end

  describe 'part 2' do
    let(:code) {
      positions  = input_data.dup
      n          = positions.size.freeze
      velocities = []
      steps      = 1
      answer     = []

      n.times { velocities << [0,0,0] }

      while true
        4.times do |i|
          (i + 1..n - 1).each do |j|
            3.times do |t|
              next if positions[i][t] == positions[j][t]

              if positions[i][t] > positions[j][t]
                velocities[i][t] -= 1
                velocities[j][t] += 1
              else
                velocities[i][t] += 1
                velocities[j][t] -= 1
              end
            end
          end

          positions[i] = positions[i].map.each_with_index {|p, k| p += velocities[i][k]}
        end

        3.times do |i|
          answer[i] = steps if velocities.all? {|v| 0 == v[i] } && input_data[0][i] == positions[0][i] && input_data[1][i] == positions[1][i] && input_data[2][i] == positions[2][i] && input_data[3][i] == positions[3][i]
        end

        break if 3 == answer.compact.size

        steps += 1
      end

      answer.inject(:lcm)
    }

    describe 'e0' do
      let(:data) { p1_e0 }

      it 'works' do
        assert_equal(2772, code)
      end
    end

    describe 'e1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal(4686774924, code / 2)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(551272644867044, code / 2)
      end
    end
  end

  let(:p1_e0) {
    <<-STR
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    STR
  }
  let(:p1_e1) {
    <<-STR
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) {
    data.lines.map {|z| z.split(', ').map {|x| x.split('=').last.to_i } }
  }
end
