class Day4
  include FileName

  REQUIRED_FIELDS = %w[
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
  ]
  OPTIONAL_FIELDS = %w[
    cid
  ]

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext))
  end

  def load_data(file)
    passports = []

    File.open(file).each_line.map do |line|
      passports << OpenStruct.new if line.blank? || passports.empty?

      next if line.blank?

      line.split(' ').each do |kvpair|
        (k, v) = kvpair.strip.split(':')

        passports.last[k] = v.strip
      end
    end

    passports
  end

  def part1
    @data.select do |p|
      REQUIRED_FIELDS.all? {|field| p[field] }
    end
  end

  def part2
    part1.select do |p|
      result = true

      result = false unless 4 == p.byr.size && p.byr.to_i >= 1920 && p.byr.to_i <= 2002
      result = false unless 4 == p.iyr.size && p.iyr.to_i >= 2010 && p.iyr.to_i <= 2020
      result = false unless 4 == p.eyr.size && p.eyr.to_i >= 2020 && p.eyr.to_i <= 2030
      result = false unless p.hcl.match?(/^#[\d|a|b|c|d|e|f]{6}$/)
      result = false unless p.ecl.in?(%w[amb blu brn gry grn hzl oth])
      result = false unless p.pid.match?(/^\d{9}$/)

      if true == result
        if p.hgt.end_with?('in')
          h = p.hgt.to_i
          result = false unless h >= 59 && h <= 76
        elsif p.hgt.end_with?('cm')
          h = p.hgt.to_i
          result = false unless h >= 150 && h <= 193
        else
          result = false
        end
      end

      result
    end
  end
end
