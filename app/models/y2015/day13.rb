module Y2015
  class Day13
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext))
    end

    def parse(line)
      result = line.match(/(?<name0>\w+) would (?<direction>(gain|lose)) (?<value>\d+) happiness units by sitting next to (?<name1>\w+).*/)
      value  = result['value'].to_i
      value  = -value if 'lose' == result['direction']

      OpenStruct.new(
        person0: result['name0'],
        person1: result['name1'],
        value: value
      )
    end

    def part1
      pairs  = {}
      people = Set.new

      @data.each do |line|
        data = parse(line)
        couple = [data.person0, data.person1].sort.join('_')
        people << data.person0 << data.person1
        pairs[couple] ||= 0
        pairs[couple]  += data.value
      end

      people.to_a.permutation(people.size).map do |order|
        score = 0

        order.size.times do |i|
          p0 = order[i - 1]
          p1 = order[i]
          r  = nil

          [p0, p1].permutation(2).find {|couple| r = pairs[couple.join('_')] }

          if r.nil?
            score  = BigDecimal::INFINITY
            break
          else
            score += r
          end
        end

        score
      end.max
    end

    def part2
      pairs  = {}
      people = Set.new
      me     = 'Zimzam'

      @data.each do |line|
        data = parse(line)
        couple = [data.person0, data.person1].sort.join('_')
        people << data.person0 << data.person1
        pairs[couple] ||= 0
        pairs[couple]  += data.value
      end

      people.each do |person|
        couple = [person, me].join('_')
        pairs[couple] = 0
      end

      people << me

      people.to_a.permutation(people.size).map do |order|
        score = 0

        order.size.times do |i|
          p0 = order[i - 1]
          p1 = order[i]
          r  = nil

          [p0, p1].permutation(2).find {|couple| r = pairs[couple.join('_')] }

          if r.nil?
            score  = BigDecimal::INFINITY
            break
          else
            score += r
          end
        end

        score
      end.max
    end
  end
end
