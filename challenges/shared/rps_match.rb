class RpsMatch
  ROCK = 1
  PAPER = 2
  SCISSORS = 3

  OPP_VALUES = {
    'A' => ROCK,
    'B' => PAPER,
    'C' => SCISSORS
  }
  PLAY_VALUES = {
    'X' => ROCK,
    'Y' => PAPER,
    'Z' => SCISSORS
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
    PLAY_VALUES[@me]
  end

  def total_score
    result_score + play_value
  end
end
