class Day5
  include FileName

  ALWAYS_NAUGHTY = %w[ab cd pq xy].freeze
  VOWELS         = %w[a e i o u].freeze

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext))
  end

  def load_data(file)
    File.open(file).each_line.map(&:chomp)
  end

  def nice?(s)
    has_double  = false
    vowel_count = 0

    return false if ALWAYS_NAUGHTY.any? {|z| s.include?(z) }

    s.chars.each_with_index do |char, i|
      has_double   = true if i > 0 && s[i - 1] == char
      vowel_count += 1 if char.in?(VOWELS)

      return true if has_double && vowel_count >= 3
    end

    return false
  end

  def nice2?(s)
    tuples = []
    skip_repeat = false
    set_repeat  = false
    working_tuple = []

    s.chars.each_with_index do |char, i|
      skip_repeat = true if i > 1 && s[i - 2] == char

      if false == set_repeat
        working_tuple << char

        case working_tuple.size
        when 2, 3
          next unless 2 == working_tuple.uniq.size

          while (working_tuple.size > 1)
            tuples << working_tuple[0..1].join
            working_tuple.shift
          end
        when 4
          if 1 == working_tuple.uniq.size
            set_repeat = true
          else
            tuples << working_tuple[0..1].join
            tuples << working_tuple[2..-1].join
            working_tuple.shift(3)
          end
        end

        set_repeat = true if tuples.size != tuples.uniq.size
      end

      return true if skip_repeat && set_repeat
    end

    case working_tuple.size
    when 2
      tuples << working_tuple[0..1].join
    when 3
      case working_tuple.uniq.size
      when 2
        tuples << working_tuple[0..1].join
      when 3
        tuples << working_tuple[0..1].join
        tuples << working_tuple[1..-1].join
      end
    when 4
      case working_tuple.uniq.size
      when 1
        set_repeat = true
      when 2
        tuples << working_tuple[0..1].join
        tuples << working_tuple[2..-1].join
      end
    end

    set_repeat = true if tuples.size != tuples.uniq.size

    return set_repeat && skip_repeat
  end

  def part1
    nice_count = 0

    @data.each do |str|
      nice_count += 1 if nice?(str)
    end

    nice_count
  end

  def part2(data = nil)
    nice_count = 0
    data ||= @data

    data.each do |str|
      nice_count += 1 if nice2?(str)
    end

    nice_count
  end
end
