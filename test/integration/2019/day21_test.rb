require 'test_helper'

class Day21Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  describe 'part 1' do
    describe 'solution' do
      let(:data) { puzzle }
      let(:springscript) {
        <<~STR
        NOT A J
        NOT B T
        OR T J
        NOT C T
        OR T J
        AND D J
        WALK
        STR
      }

      it 'works' do
        answer = ElfComputer.new([], input_data, no_input_mode: :break).run(springscript.chars.map(&:ord)).output

        if answer.last > 'Z'.ord
          answer = answer.last
        else
          answer = answer.map(&:chr).join()
        end

        assert_equal(19354392, answer)
      end
    end
  end

  describe 'part 2' do
    describe 'solution' do
      let(:data) { puzzle }
      let(:springscript) {
        <<~STR
        NOT A J
        NOT B T
        OR T J
        NOT C T
        OR T J
        AND D J
        NOT H T
        NOT T T
        OR E T
        AND T J
        RUN
        STR
      }

      it 'works' do
        answer = ElfComputer.new([], input_data, no_input_mode: :break).run(springscript.chars.map(&:ord)).output

        if answer.last > 'Z'.ord
          answer = answer.last
        else
          answer = answer.map(&:chr).join()
        end

        assert_equal(1139528802, answer)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(',').map(&:to_i) }
end
