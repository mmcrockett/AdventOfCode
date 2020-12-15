require 'test_helper'

class Day7Test < ActiveSupport::TestCase
  let(:example0) { '3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0' }
  let(:example1) { '3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0' }
  let(:example2) { '3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0' }
  let(:example3) { '3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5' }
  let(:example4) { '3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10' }
  let(:puzzle) { read_test_file(File.join('aoc', 'day7_input.txt')) }
  let(:input_data) { data.split(',').map(&:to_i) }

  describe 'part 1' do
    describe 'example0' do
      let(:data) { example0 }

      it 'works' do
        input = 0

        [4,3,2,1,0].each do |phase|
          input = ElfComputer.new([phase, input], input_data).run.output.last
        end

        assert_equal(43210, input)
      end
    end

    describe 'example1' do
      let(:data) { example1 }

      it 'works' do
        input = 0

        [0,1,2,3,4].each do |phase|
          input = ElfComputer.new([phase, input], input_data).run.output.last
        end

        assert_equal(54321, input)
      end
    end

    describe 'example2' do
      let(:data) { example2 }

      it 'works' do
        input = 0

        [1,0,4,3,2].each do |phase|
          input = ElfComputer.new([phase, input], input_data).run.output.last
        end

        assert_equal(65210, input)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        max = 0

        (0..4).to_a.permutation.each do |phases|
          input = 0

          phases.each do |phase|
            input = ElfComputer.new([phase, input], input_data).run.output.last
          end

          max = input if input > max
        end

        assert_equal(437860, max)
      end
    end
  end

  describe 'part 2' do
    let(:permutations) { (5..9).to_a.permutation }
    let(:run_it) {
      max = 0

      permutations.each do |phases|
        input  = 0
        output = 0
        ecs    = []
        index  = 0

        phases.each_with_index do |phase, i|
          ecs << ElfComputer.new(phase, input_data, loop_mode: true, name: "ec#{i}")
        end

        while true
          input  = output

          output = ecs[index].run(input).output.last

          break if true == output.nil?

          index  = (index + 1) % ecs.size
        end

        max = input if input > max
      end

      max
    }

    describe 'example3' do
      let(:data) { example3 }

      it 'works' do
        assert_equal(139629729, run_it)
      end
    end

    describe 'example4' do
      let(:data) { example4 }

      it 'works' do
        assert_equal(18216, run_it)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_not_equal(24905296, run_it)
        assert_not_equal(49810592, run_it)
        assert_equal(49810599, run_it)
      end
    end
  end
end
