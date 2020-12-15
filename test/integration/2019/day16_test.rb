require 'test_helper'

class Day16Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  let(:multiple) {
    ->(idx, size) {
      mult = [0, 1, 0, -1].freeze

      (mult.map {|v| idx.times.map {|i| v } }.flatten * (size / mult.size + 1))[1..-1]
    }
  }
  let(:code) {
    output = input_data.dup
    input  = nil

    n.times do
      input  = output
      output = []

      input.size.times do |t|
        multipliers = multiple.call(t + 1, input.size)

        output << (input.sum {|v| v * multipliers.shift }.abs % 10)
      end

      puts "#{output}" if 4 == n && true == @debug
    end

    output
  }

  describe 'part 1' do
    let(:n) { 100 }

    describe 'long example' do
      let(:n) { 4 }
      let(:data) { '12345678' }

      it 'works' do
        assert_equal('01029498', code.join(''))
      end
    end

    describe 'example 0' do
      let(:data) { p1_e0 }

      it 'works' do
        assert_equal('24176176', code.first(8).join(''))
      end
    end

    describe 'example 1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal('73745418', code.first(8).join(''))
      end
    end

    describe 'example 2' do
      let(:data) { p1_e2 }

      it 'works' do
        assert_equal('52432133', code.first(8).join(''))
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal('59281788', code.first(8).join(''))
      end
    end
  end

  describe 'part 2' do
    let(:n) { 100 }
    let(:x) { 10000 }
    let(:offset) { input_data.first(7).join('').to_i }
    let(:reduced_data) { input_data[offset..-1] }
    let(:code) {
      d = reduced_data.dup

      n.times do
        (d.size - 2).downto(0) do |i|
          d[i] = (d[i] + d[i + 1]) % 10
        end
      end

      d
    }

    describe 'example 0' do
      let(:data) { p2_e0 * x }

      it 'works' do
        assert_equal('84462026', code.first(8).join(''))
      end
    end

    describe 'example 1' do
      let(:data) { p2_e1 * x }

      it 'works' do
        assert_equal('78725270', code.first(8).join(''))
      end
    end

    describe 'example 2' do
      let(:data) { p2_e2 * x }

      it 'works' do
        assert_equal('53553731', code.first(8).join(''))
      end
    end

    describe 'solution' do
      let(:data) { puzzle.chomp * x }

      it 'works' do
        assert_equal('96062868', code.first(8).join(''))
      end
    end
  end

  let(:p1_e0) { '80871224585914546619083218645595' }
  let(:p1_e1) { '19617804207202209144916044189917' }
  let(:p1_e2) { '69317163492948606335995924319873' }
  let(:p2_e0) { '03036732577212944063491565474664' }
  let(:p2_e1) { '02935109699940807407585447034323' }
  let(:p2_e2) { '03081770884921959731165446850517' }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.chars.map(&:to_i) }
end
