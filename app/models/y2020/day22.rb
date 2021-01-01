module Y2020
  class Day22
    include FileName

    def initialize(file: nil, file_ext: nil, preamble_size: 25)
      @hands = []

      load_data(file_name(file: file, file_ext: file_ext)).each do |line|
        if line.starts_with?('Player')
          @hands << [] 
        elsif false == line.empty?
          @hands.last << line.to_i
        end
      end
    end

    def play!(hand0, hand1)
      while false == hand0.empty? && false == hand1.empty?
        (card0, card1) = [hand0.shift, hand1.shift]

        if card0 > card1
          hand0 << card0 << card1
        elsif card1 > card0
          hand1 << card1 << card0
        else
          raise "#{card0}:#{card1}"
        end
      end

      hand0.empty? ? hand1 : hand0
    end

    def recursive_play!(hand1, hand2)
      seen_hands = {}

      while false == hand1.empty? && false == hand2.empty?
        return [['player 1 win'], []] if seen_hands.include?("p1_#{hand1.join('_')}") || seen_hands.include?("p2_#{hand2.join('_')}")

        seen_hands["p1_#{hand1.join('_')}"] = true
        seen_hands["p2_#{hand2.join('_')}"] = true

        (card1, card2) = [hand1.shift, hand2.shift]

        if hand1.size >= card1 && hand2.size >= card2
          (r1, r2) = recursive_play!(hand1[0, card1], hand2[0, card2])

          if r1.empty?
            hand2 << card2 << card1
          elsif r2.empty?
            hand1 << card1 << card2
          else
            raise 'Recursive ended prematurely'
          end
        else
          if card1 > card2
            hand1 << card1 << card2
          elsif card2 > card1
            hand2 << card2 << card1
          else
            raise "#{card1}:#{card2}"
          end
        end
      end

      [hand1, hand2]
    end

    def score(hand)
      hand.reverse.each_with_index.map do |v, i|
        v * (i + 1)
      end.sum
    end

    def part1
      score(play!(*@hands))
    end

    def part2
      score(recursive_play!(*@hands).find {|v| false == v.empty?})
    end
  end
end
