module Y2020
  class Ticket
    attr_reader :values

    def initialize(d)
      @values = d.split(',').map(&:to_i)
    end
  end

  class Day16
    include FileName

    def initialize(file: nil, file_ext: nil)
      @rules = {}
      @tickets = []

      load_data(file_name(file: file, file_ext: file_ext)).each do |line|
        match_data = line.match(/(?<name>(\s|\w)+): (?<r0start>\d+)-(?<r0end>\d+) or (?<r1start>\d+)-(?<r1end>\d+)/)

        if match_data.nil?
          if line.include?(',')
            ticket = Ticket.new(line)

            @tickets << ticket
          end
        else
          @rules[match_data['name']]  = (match_data['r0start'].to_i..match_data['r0end'].to_i).to_a
          @rules[match_data['name']] += (match_data['r1start'].to_i..match_data['r1end'].to_i).to_a
        end
      end

      @mine = @tickets.shift
    end

    def valid_values
      @valid_values ||= @rules.values.flatten.uniq.freeze
    end

    def rules_departure_keys
      @dkeys ||= departure_keys(@rules)
    end

    def departure_keys(h)
      h.each_key.select {|k| k.start_with?('departure') }
    end

    def valid_tickets
      @valid_tickets ||= @tickets.select do |ticket|
        ticket.values.all? {|v| valid_values.include?(v) }
      end
    end

    def part1
      @tickets.map do |ticket|
        next if valid_tickets.include?(ticket)

        ticket.values.map do |v|
          v if valid_values.exclude?(v)
        end
      end.flatten.compact.sum
    end

    def valid_tickets_to_options
      @valid_tickets_map ||= valid_tickets.map do |ticket|
        ticket.values.map do |value|
          @rules.map do |rule, valid_values|
            rule if valid_values.include?(value)
          end.flatten
        end
      end
    end

    def part2
      solved = {}
      possible_answers = Hash[@rules.keys.size.times.map {|i| [i, valid_tickets_to_options.map {|r| r[i] }.reduce(&:&)] }]

      while departure_keys(solved).size != rules_departure_keys.size
        one_answer = possible_answers.select {|ki, answer| 1 == answer.size }
        one_option = possible_answers.values.flatten.group_by {|answer| answer }.select {|value, values| 1 == values.size }
        one_option = Hash[one_option.keys.map {|option| [possible_answers.find {|k, v| v.include?(option) }.first, option] }]

        one_option.each do |ki, answer|
          solved[answer] = ki
          possible_answers.delete(ki)
        end

        one_answer.each do |ki, answer|
          solved[answer.last] = ki

          possible_answers.each do |k, v|
            v.delete(answer.last)
          end
        end
      end

      rules_departure_keys.map do |dkey|
        @mine.values[solved[dkey]]
      end.reduce(&:*)
    end
  end
end
