class Day3
  include FileName

  def initialize(file: nil, file_ext: nil)
    @data     = load_data(file_name(file: file, file_ext: file_ext))
  end

  def load_data(file)
    File.open(file).each_line.map(&:chomp)[0]
  end

  def add_to(l, i, amount)
    l[i] += amount
  end

  def part1
    location = [0,0]
    presents = { location.join('_') => 1 }

    @data.chars.each do |direction|
      case direction
      when '>'
        location[0] += 1
      when '<'
        location[0] -= 1
      when '^'
        location[1] += 1
      when 'v'
        location[1] -= 1
      else
        raise "!ERROR: #{direction}"
      end

      presents[location.join('_')] ||= 0
      presents[location.join('_')]  += 1
    end

    presents
  end

  def part2
    slocation = [0,0]
    rlocation = [0,0]
    presents = { slocation.join('_') => 2 }

    @data.chars.each_with_index do |direction, i|
      loc = i.even? ? slocation : rlocation

      case direction
      when '>'
        add_to(loc, 0, 1)
      when '<'
        add_to(loc, 0, -1)
      when '^'
        add_to(loc, 1, 1)
      when 'v'
        add_to(loc, 1, -1)
      else
        raise "!ERROR: #{direction}"
      end

      presents[loc.join('_')] ||= 0
      presents[loc.join('_')]  += 1
    end

    presents
  end
end
