class String
  def xor(other)
    my_chars = self.chars
    new_str  = ''

    other.chars.each do |other_char|
      new_str << other_char if my_chars.include?(other_char)
    end

    new_str
  end
end

class Day6
  include FileName

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext))
  end

  def load_data(file)
    groups = []

    File.open(file).each_line.map(&:chomp).each do |line|
      groups << [] if line.blank? || groups.blank?
      next if line.blank?
      groups.last << line
    end

    groups
  end

  def part1
    @data.map do |group|
      group.map(&:chars).flatten.uniq
    end
  end

  def part2
    @data.map do |group|
      group.reduce(&:xor)
    end
  end
end
