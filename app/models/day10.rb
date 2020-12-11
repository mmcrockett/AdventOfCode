class Day10
  include FileName

  PART1_ANSWER = 14360655

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext)).map(&:to_i)
  end

  def goal
    @goal ||= @data.max + 3
  end

  def part1
    data = @data.sort
    distribution = {
      3 => 1
    }

    data.sort.each_with_index do |v, i|
      last_value = i.zero? ? 0 : data[i - 1]
      diff = v - last_value

      distribution[diff] ||= 0
      distribution[diff] += 1
    end

    distribution
  end

  def part2
    # reddit lookup, never understood it
    data = [0] + @data + [goal]
    data = data.sort

    friends = data.each_with_index.map do |adapter, index|
      [adapter, data[index + 1, 3].select { |a| a <= adapter + 3 }]
    end

    scores = []

    friends.reverse.each do |adapter, set|
      scores[adapter] = set.size.zero? ? 1 : set.map { |friend| scores[friend] }.sum
    end

    scores.first
  end
end
