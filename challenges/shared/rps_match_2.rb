class RpsMatch2
  ROCK = 1
  PAPER = 2
  SCISSORS = 3

  OPP_VALUES = {
    'A' => ROCK,
    'B' => PAPER,
    'C' => SCISSORS
  }

  def initialize(other, me)
    @other = other
    @me = me
  end

  def result_score
    result = (opp_value - play_value)
    return 3 if 0 == result
    return 0 if [1, -2].include?(result)

    6
  end

  def opp_value
    OPP_VALUES[@other]
  end

  def play_value
    if @me == 'X'
      if @other == 'A'
        SCISSORS
      elsif @other == 'B'
        ROCK
      elsif @other == 'C'
        PAPER
      end
    elsif @me == 'Y'
      opp_value
    elsif @me == 'Z'
      if @other == 'A'
        PAPER
      elsif @other == 'B'
        SCISSORS
      elsif @other == 'C'
        ROCK
      end
    else
      raise @me
    end
  end

  def total_score
    result_score + play_value
  end
end
