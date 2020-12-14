class Day11
  include FileName

  EMPTY = 'L'
  OCCUPIED  = '#'
  FLOOR = '.'

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext))
    @size = @data.size
  end

  def height
    @h ||= @data.size
  end

  def width
    @w ||= @data.first.chars.size
  end

  def any_occupied?(data, i, j)
    [-1, 0, 1].each do |ix|
      [-1, 0, 1].each do |jx|
        next if ix.zero? && jx.zero?
        next if (i + ix).negative? || (j + jx).negative?
        next if (i + ix) >= height || (j + jx) >= width

        return true if occupied?(data[i + ix][j + jx])
      end
    end

    return false
  end

  def too_many_occupied?(data, i, j)
    count = 0

    [-1, 0, 1].map do |ix|
      [-1, 0, 1].map do |jx|
        next if ix.zero? && jx.zero?
        next if (i + ix).negative? || (j + jx).negative?
        next if (i + ix) >= height || (j + jx) >= width

        count += 1 if occupied?(data[i + ix][j + jx])

        return true if count >= 4
      end
    end

    return false
  end

  def floor?(seat)
    FLOOR == seat
  end

  def empty?(seat)
    EMPTY == seat
  end

  def occupied?(seat)
    OCCUPIED == seat
  end

  def part1
    last_round = @data.map {|row| row.chars }
    this_round = nil

    while last_round != this_round
      last_round = this_round if this_round.present?
      this_round = []

      last_round.each_with_index do |row, i|
        this_round[i] ||= []

        row.each_with_index do |seat, j|
          if floor?(seat)
            this_round[i][j] = seat
          elsif empty?(seat)
            this_round[i][j] = any_occupied?(last_round, i, j) ? EMPTY : OCCUPIED
          elsif occupied?(seat)
            this_round[i][j] = too_many_occupied?(last_round, i, j) ? EMPTY : OCCUPIED
          else
            raise "Unknown seat #{seat}"
          end
        end
      end
    end

    this_round
  end

  def any_visibly_occupied?(data, i, j)
    slopes = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

    slopes.each do |yd, xd|
      new_i = i + yd
      new_j = j + xd

      while !new_i.negative? && !new_j.negative? && new_i < height && new_j < width
        return true if occupied?(data[new_i][new_j])

        break unless floor?(data[new_i][new_j])

        new_i += yd
        new_j += xd
      end
    end

    return false
  end

  def too_many_visibly_occupied?(data, i, j)
    count  = 0
    slopes = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

    slopes.each do |yd, xd|
      new_i = i + yd
      new_j = j + xd

      while !new_i.negative? && !new_j.negative? && new_i < height && new_j < width
        count += 1 if occupied?(data[new_i][new_j])

        return true if count >= 5

        break unless floor?(data[new_i][new_j])

        new_i += yd
        new_j += xd
      end
    end

    return false
  end

  def print(grid)
    puts grid.map {|row| row.join }
  end

  def part2
    last_round = @data.map {|row| row.chars }
    this_round = nil
    round      = nil

    while last_round != this_round
      last_round = this_round if this_round.present?
      this_round = []

      last_round.each_with_index do |row, i|
        this_round[i] ||= []

        row.each_with_index do |seat, j|
          if floor?(seat)
            this_round[i][j] = seat
          elsif empty?(seat)
            this_round[i][j] = any_visibly_occupied?(last_round, i, j) ? EMPTY : OCCUPIED
          elsif occupied?(seat)
            this_round[i][j] = too_many_visibly_occupied?(last_round, i, j) ? EMPTY : OCCUPIED
          else
            raise "Unknown seat #{seat}"
          end
        end
      end

      if round.present?
        round += 1

        expected_data = load_data("/Users/mcrockett/tmp/day11.expected.#{round}").map {|row| row.chars }

        debugger unless this_round == expected_data

        print(expected_data)
        print(this_round)
      end
    end

    this_round
  end
end
