module Y2015
  class Day14
    include FileName

    def initialize(file: nil, file_ext: nil)
      @deers = load_data(file_name(file: file, file_ext: file_ext)).map do |line|
        matcher = line.match(/(?<name>\w+) can fly (?<speed>\d+) km.* for (?<tfly>\d+) seconds.*rest for (?<trest>\d+) second.*/)

        OpenStruct.new(
          name: matcher['name'],
          speed: matcher['speed'].to_i,
          tfly: matcher['tfly'].to_i,
          trest: matcher['trest'].to_i,
        )
      end
    end

    def part1(t = 2503)
      @deers.map do |deer|
        ttime     = deer.tfly + deer.trest
        cycles    = t / ttime
        remainder = t % ttime

        flyt      = cycles * deer.tfly + (remainder >= deer.tfly ? deer.tfly : remainder)
        flyt * deer.speed
      end
    end

    def part2(t = 2503)
      points   = {}
      distance = {}

      t.times do |i|
        @deers.map do |deer|
          points[deer.name]   ||= 0
          distance[deer.name] ||= 0

          ttime     = deer.tfly + deer.trest

          distance[deer.name] += deer.speed if (i % ttime) < deer.tfly
        end

        max = distance.values.max

        distance.each do |k,v|
          points[k] += 1 if v == max
        end
      end

      points
    end
  end
end
