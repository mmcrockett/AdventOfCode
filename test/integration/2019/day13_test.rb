require 'test_helper'

class Day13Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  describe 'part 1' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        answer = ElfComputer.new([], input_data).run.output
        screen = {}

        while (false == answer.empty?)
          (x, y, t) = answer.shift(3)

          screen["#{x}_#{y}"] = t
        end

        assert_equal(412, screen.values.select {|v| 2 == v}.size)
      end
    end
  end

  describe 'part 2' do
    describe 'solution' do
      let(:data) { puzzle }
      let(:free_play) { fp = input_data.dup; fp[0] = 2; fp }
      let(:ec) { ElfComputer.new([], free_play, no_input_mode: :break) }
      let(:show_display) { false }

      it 'works' do
        screen = []
        move   = nil
        score  = 0

        while (false == ec.halted?)
          ball_x   = nil
          paddle_x = nil

          ec.run if move.nil?
          ec.run(move) if move.present?

          while (false == ec.output.empty?)
            (x, y, t) = ec.output.shift(3)

            if -1 == x && 0 == y
              score = t
            else
              screen[y] ||= []
              screen[y][x] = t
            end
          end

          screen.each_with_index do |line, y|
            puts '' if show_display

            line.each_with_index do |v, x|
              print ElfComputer::GAME_OUTPUT.call(v) if show_display
              ball_x   = x if 4 == v
              paddle_x = x if 3 == v
            end
          end

          if show_display
            sleep(0.2)
            system(:clear.to_s)
          end

          move = 1 if paddle_x < ball_x
          move = -1 if paddle_x > ball_x
          move = 0 if paddle_x == ball_x
        end

        assert_equal(20940, score)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(',').map(&:to_i) }
end
