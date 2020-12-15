require 'test_helper'

class Day19Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  let(:result) {
    ->(d, x, y) {
      ElfComputer.new([x,y], d.dup, loop_mode: true).run.output.first 
    }
  }

  describe 'part 1' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        total = 0
        n     = 50
        lmx   = 0

        n.times do |y|
          min_x = (lmx..n).find {|x| 1 == result.call(input_data, x, y) }
          max_x = (min_x..n).find {|x| 0 == result.call(input_data, x, y) } if min_x.present?
          max_x ||= (n - 1)
          lmx   = min_x if min_x.present?

          total += max_x - min_x if min_x.present?
        end

        assert_equal(173, total)
      end
    end
  end

  describe 'part 2' do
    let(:data) { puzzle }
    let(:n) { 10000 }
    let(:size) { 100 }
    let(:check_it) {
      ->(d, x, y) {
        [[x + 99, y], [x, y + 99]].all? do |xi,yi|
          1 == result.call(d.dup, xi, yi)
        end
      }
    }

    describe 'solution' do
      it 'works' do
        min_x = nil
        max_x = nil
        rx    = nil
        stime = Time.now
        timing_on = false
        p0    = [(0..n).find {|x| 1 == result.call(input_data, x, 50) }, 50]
        p1    = [(0..n).find {|x| 1 == result.call(input_data, x, 100) }, 100]

        slope = p0.create_line(p1).slope

        start_y = (size..n).bsearch do |y|
          start_x = (y.to_f * slope[:x] / slope[:y]).ceil
          lx = (start_x..n).find {|x| 1 == result.call(input_data, x, y) }
          mx = (lx..n).bsearch {|x| 0 == result.call(input_data, x, y) } if lx.present?

          lx.present? && (mx - lx) >= 100
        end

        puts "\nBSEARCH: #{Time.now - stime}:#{start_y}" if timing_on
        stime = Time.now

        answer_y = (start_y..n).find do |y|
          min_x = (min_x.to_i..n).find {|x| 1 == result.call(input_data, x, y) }
          max_x = (min_x..n).bsearch {|x| 0 == result.call(input_data, x, y) }

          rx    = check_it.call(input_data, max_x - 100, y)
          min_x.present? && rx
        end

        puts "\nFIND: #{Time.now - stime}" if timing_on

        answer = (min_x..max_x).find {|x| check_it.call(input_data, x, answer_y) } * 10_000 + answer_y

        assert(50017161 > answer)
        assert(49017161 > answer)
        assert(40477161 > answer)
        assert_not_equal(6141100, answer)
        assert_not_equal(6721107, answer)
        assert_not_equal(3950708, answer)
        assert_equal(6671097, answer)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(',').map(&:to_i) }
end
