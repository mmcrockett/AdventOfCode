require 'test_helper'

class Day9Test < ActiveSupport::TestCase
  let(:p1_e0) { '109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99' }
  let(:p1_e1) { '1102,34915192,34915192,7,4,7,99,0' }
  let(:p1_e2) { '104,1125899906842624,99' }
  let(:puzzle) { read_test_file(File.join('aoc', 'day9_input.txt')).chomp }
  let(:input_data) { data.split(',').map(&:to_i) }

  describe 'part 1' do
    describe 'example0' do
      let(:data) { p1_e0 }

      it 'works' do
        assert_equal(input_data, ElfComputer.new([], input_data).run.output)
      end
    end

    describe 'example1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal(16, ElfComputer.new([], input_data).run.output.last.to_s.size)
      end
    end

    describe 'example2' do
      let(:data) { p1_e2 }

      it 'works' do
        assert_equal(1125899906842624, ElfComputer.new([], input_data).run.output.last)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal([3906448201], ElfComputer.new(1, input_data).run.output)
      end
    end
  end

  describe 'part 2' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(0, ElfComputer.new(2, input_data).run.output)
      end
    end
  end
end
