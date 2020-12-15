require 'test_helper'

class Day5Test < ActiveSupport::TestCase
  let(:example2_eq_pos) { '3,9,8,9,10,9,4,9,99,-1,8' }
  let(:example2_lt_pos) { '3,9,7,9,10,9,4,9,99,-1,8' }
  let(:example2_eq_imm) { '3,3,1108,-1,8,3,4,3,99' }
  let(:example2_lt_imm) { '3,3,1107,-1,8,3,4,3,99' }
  let(:example2_jt_pos) { '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9' }
  let(:example2_jt_imm) { '3,3,1105,-1,9,1101,0,0,12,4,12,99,1' }
  let(:example2_large) { '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99' }
  let(:puzzle) { read_test_file(File.join('aoc', 'day5_input.txt')) }

  describe 'part 1' do
    let(:data) { puzzle.split(',').map(&:to_i) }
    let(:input) { 1 }
    let(:code) { ElfComputer.new(input, data).run }

    it 'works' do
      assert_equal(11049715, code.output.last)
    end
  end

  describe 'part 2' do
    describe 'position mode' do
      describe 'equal to 8' do
        let(:data) { example2_eq_pos.split(',').map(&:to_i) }

        describe '1 on input of 8' do
          let(:input) { 8 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(1, code.output.last)
          end
        end

        describe '0 on other inputs' do
          let(:input) { 37 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(0, code.output.last)
          end
        end
      end

      describe '< 8' do
        let(:data) { example2_lt_pos.split(',').map(&:to_i) }

        describe '0 on input >= 8' do
          let(:input) { 8 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(0, code.output.last)
          end
        end

        describe '1 on < 8' do
          let(:input) { 2 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(1, code.output.last)
          end
        end
      end
    end

    describe 'immediate mode' do
      describe 'equal to 8' do
        let(:data) { example2_eq_imm.split(',').map(&:to_i) }

        describe '1 on input of 8' do
          let(:input) { 8 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(1, code.output.last)
          end
        end

        describe '0 on other inputs' do
          let(:input) { 37 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(0, code.output.last)
          end
        end
      end

      describe '< 8' do
        let(:data) { example2_lt_imm.split(',').map(&:to_i) }

        describe '0 on input >= 8' do
          let(:input) { 8 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(0, code.output.last)
          end
        end

        describe '1 on < 8' do
          let(:input) { 2 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(1, code.output.last)
          end
        end
      end
    end

    describe 'jump mode' do
      describe 'immediate' do
        let(:data) { example2_jt_imm.split(',').map(&:to_i) }

        describe '0 on 0' do
          let(:input) { 0 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(0, code.output.last)
          end
        end

        describe '1 on other' do
          let(:input) { 37 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(1, code.output.last)
          end
        end
      end

      describe 'position' do
        let(:data) { example2_jt_pos.split(',').map(&:to_i) }

        describe '0 on 0' do
          let(:input) { 0 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(0, code.output.last)
          end
        end

        describe '1 on other' do
          let(:input) { 2 }
          let(:code) { ElfComputer.new(input, data).run }

          it 'works' do
            assert_equal(1, code.output.last)
          end
        end
      end
    end

    describe 'large example' do
      let(:data) { example2_large.split(',').map(&:to_i) }

      describe '< 8' do
        let(:input) { 7 }
        let(:code) { ElfComputer.new(input, data).run }

        it 'works' do
          assert_equal(999, code.output.last)
        end
      end
    end

    describe 'works' do
      let(:data) { puzzle.split(',').map(&:to_i) }
      let(:input) { 5 }
      let(:code) { ElfComputer.new(input, data).run }

      describe '< 8' do
        it 'works' do
          assert_equal(2140710, code.output.last)
        end
      end
    end
  end
end
