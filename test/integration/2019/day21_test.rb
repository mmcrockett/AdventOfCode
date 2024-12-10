require "test_helper"

class Day21Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{name.underscore}.txt"

  describe "part 1" do
    describe "solution" do
      let(:data) { puzzle }
      let(:springscript) do
        <<~STR
          NOT A J
          NOT B T
          OR T J
          NOT C T
          OR T J
          AND D J
          WALK
        STR
      end

      it "works" do
        answer = ElfComputer.new([], input_data, no_input_mode: :break).run(springscript.chars.map(&:ord)).output

        answer = if answer.last > "Z".ord
                   answer.last
        else
                   answer.map(&:chr).join
        end

        assert_equal(19_354_392, answer)
      end
    end
  end

  describe "part 2" do
    describe "solution" do
      let(:data) { puzzle }
      let(:springscript) do
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
      end

      it "works" do
        answer = ElfComputer.new([], input_data, no_input_mode: :break).run(springscript.chars.map(&:ord)).output

        answer = if answer.last > "Z".ord
                   answer.last
        else
                   answer.map(&:chr).join
        end

        assert_equal(1_139_528_802, answer)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join("aoc", PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(",").map(&:to_i) }
end
