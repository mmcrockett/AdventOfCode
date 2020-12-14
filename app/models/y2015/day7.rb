module Y2015
  class Gate
    attr_reader :input, :output, :value

    def initialize(output: , input: , func: )
      @output = output
      @input  = input
      @func   = func || 'wire'
      @value  = func.present? ? nil : input.first
    end

    def and(a, b) a & b end
    def or(a, b) a | b end
    def lshift(v, n) v << n end
    def rshift(v, n) v >> n end
    def wire(v) v end
    def not(v)
      65536 + (~v)
    end

    def to_s
      "#{@input[0]} #{@func} #{@input[1]} -> #{@output}"
    end

    def resolved?
      Gate.integer_str?(@value)
    end

    def resolve(input, value)
      @input = @input.map {|v| v == input ? value : v }

      if @input.all? {|v| Gate.integer_str?(v) }
        @value = self.send(@func, *@input.map(&:to_i))
      end

      @output
    end

    def wire?
      @func.nil?
    end

    def change_value(v)
      @value = v
    end

    def self.integer_str?(v)
      v.present? && v.to_s == "#{v.to_i}"
    end
  end

  class Day7
    # 162 too low
    include FileName

    def initialize(file: nil, file_ext: nil)
      @raw_data = load_data(file_name(file: file, file_ext: file_ext))
      reset_data
    end

    def reset_data
      @data = @raw_data.map {|d| parse(d) }
    end

    def parse(str)
      a = nil
      b = nil
      g = nil

      (input, output) = str.split(' -> ')

      matcher = input.match(/(?<a>\w+)\s(?<gate>AND|OR|LSHIFT|RSHIFT)\s(?<b>\w+)/)

      if matcher.present?
        a = matcher['a']
        b = matcher['b']
        g = matcher['gate']
      elsif input.start_with?('NOT')
        (g, a) = input.split(' ')
      else
        a = input
      end

      Gate.new(
        output: output.strip,
        input: [a, b].compact,
        func: g&.downcase
      )
    end

    def part1
      output_map = {}

      data = @data.dup

      while data.present?
        data.each do |gate|
          if gate.resolved?
            output_map[gate.output] = gate.value
          else
            gate.input.each do |input|
              gate.resolve(input, output_map[input]) if Gate.integer_str?(output_map[input])
            end
          end
        end

        data = data.reject {|gate| gate.resolved? && output_map.include?(gate.output) }
      end

      output_map
    end

    def part2
      part1_a = self.part1['a']

      reset_data

      @data = @raw_data.map {|d| parse(d) }

      b_gate = @data.find {|gate| gate.output == 'b' }
      b_gate.change_value(part1_a)

      self.part1
    end
  end
end
