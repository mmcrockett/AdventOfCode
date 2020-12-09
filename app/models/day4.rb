class Day4
  include FileName

  E0 = 'abcdef'
  E1 = 'pqrstuv'
  D  = 'bgvyzdsv'

  def initialize(data)
    @data = data
  end

  def part1
    i = 0

    while true
      break if Digest::MD5.hexdigest("#{@data}#{i}").start_with?('00000')
      i += 1
    end

    i
  end

  def part2
    i = 0

    while true
      break if Digest::MD5.hexdigest("#{@data}#{i}").start_with?('000000')
      i += 1
    end

    i
  end
end
