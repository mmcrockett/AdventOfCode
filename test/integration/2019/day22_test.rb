require 'test_helper'

class Day22Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  describe 'part 1' do
    let(:deal) {
      ->(cards, n) {
        cards.reverse
      }
    }
    let(:cut) {
      ->(cards, n) {
        cards.rotate(n)
      }
    }
    let(:increment) {
      ->(cards, n) {
        new_cards = []

        cards.size.times {|t| new_cards[(t * n) % cards.size] = cards[t] }
        new_cards
      }
    }
    let(:answer) {
      results = deck.dup
      input_data.each do |c, n|
        results = send(c).call(results, n)
      end
      results
    }

    describe 'examples' do
      let(:deck) { 10.times.to_a }

      describe 'example 0' do
        let(:data) { p1_e0 }

        it 'works' do
          assert_equal('0 3 6 9 2 5 8 1 4 7'.split(' ').map(&:to_i), answer)
        end
      end

      describe 'example 1' do
        let(:data) { p1_e1 }

        it 'works' do
          assert_equal('3 0 7 4 1 8 5 2 9 6'.split(' ').map(&:to_i), answer)
        end
      end

      describe 'example 2' do
        let(:data) { p1_e2 }

        it 'works' do
          assert_equal('6 3 0 7 4 1 8 5 2 9'.split(' ').map(&:to_i), answer)
        end
      end

      describe 'example 3' do
        let(:data) { p1_e3 }

        it 'works' do
          assert_equal('9 2 5 8 1 4 7 0 3 6'.split(' ').map(&:to_i), answer)
        end
      end
    end

    describe 'solution' do
      let(:data) { puzzle }
      let(:deck) { 10007.times.to_a }

      it 'works' do
        assert_equal(4684, answer.find_index(2019))
      end

      it 'has test for part 2' do
        assert_equal(3858, answer[2020])
      end
    end
  end

  describe 'part 2' do
    let(:data) { puzzle.dup }
    let(:reduce) {
      ->(l, rules) {
        a = 1
        b = 0

        rules.each do |c, n|
          la = nil
          lb = nil

          if c == :deal
            la = -1
            lb = -1
          elsif c == :increment
            la = n
            lb = 0
          elsif c == :cut
            la = 1
            lb = -n
          else
            raise "Unknown #{c}"
          end

          a = (la * a) % deck_size
          b = (la * b + lb) % deck_size
        end

        [a, b]
      }
    }
    let(:polypow) {
      ->(a, b, m, n) {
        new_inc = 1
        new_off = 0

        if 0 == m
          [1, 0]
        elsif m.even?
          polypow.call((a * a) % n, ((a * b) + b) % n, m / 2, n)
        else
          c,d = polypow.call(a, b, m - 1, n)
          [a * c % n, ((a * d) + b) % n]
        end
      }
    }
    let(:answer) {
      p = 2020

      (a, b) = reduce.call(deck_size, input_data)

      assert_equal(8067652995194, a) if @check_intermediate
      assert_equal(90670298010248, b) if @check_intermediate

      ma = a.pow(shuffles, deck_size)

      assert_equal(71126595274540, ma) if @check_intermediate

      mb = (b * (ma - 1) * (a - 1).pow(deck_size - 2, deck_size)) % deck_size

      assert_equal(26522924041810, mb) if @check_intermediate

      ((p - mb) * ma.pow(deck_size - 2, deck_size)) % deck_size
    }

    describe 'test part 1 works' do
      let(:deck_size) { 10007 }
      let(:shuffles) { 1 }

      it 'works' do
        assert_equal(3858, answer)
      end
    end

    describe 'solution' do
      let(:deck_size) { 119315717514047 }
      let(:shuffles) { 101_741_582_076_661 }

      it 'works' do
        @check_intermediate = true
        assert_equal(452290953297, answer)
      end
    end
  end

  let(:p1_e0) {
    <<~STR
    deal with increment 7
    deal into new stack
    deal into new stack
    STR
  }
  let(:p1_e1) {
    <<~STR
    cut 6
    deal with increment 7
    deal into new stack
    STR
  }
  let(:p1_e2) {
    <<~STR
    deal with increment 7
    deal with increment 9
    cut -2
    STR
  }
  let(:p1_e3) {
    <<~STR
    deal into new stack
    cut -2
    deal with increment 7
    cut 8
    cut -4
    deal with increment 7
    cut 3
    deal with increment 9
    deal with increment 3
    cut -1
    STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) {
    commands = []
    data.lines.map(&:chomp).each do |line|
      if line.end_with?('new stack')
        commands << [:deal, nil]
      elsif line.start_with?('deal with increment')
        commands << [:increment, line.split(' ').last.to_i]
      elsif line.start_with?('cut')
        commands << [:cut, line.split(' ').last.to_i]
      else
        raise "Unknown command '#{line}'"
      end
    end
    commands
  }
end
