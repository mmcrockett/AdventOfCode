module Y2020
  class Day6
    include FileName

    attr_reader :lights

    TOGGLE = 'toggle'
    TURN   = 'turn'

    def initialize(file: nil, file_ext: nil)
      @data   = load_data(file_name(file: file, file_ext: file_ext))
      @lights = []
    end

    def load_data(file)
      File.open(file).each_line.map(&:chomp).map {|line| instruction(line) }
    end

    def instruction(str)
      parts = str.split(' ')

      (start_x, start_y) = parts[-3].split(',')
      (end_x, end_y)     = parts[-1].split(',')

      OpenStruct.new(
        start_x: start_x.to_i,
        start_y: start_y.to_i,
        end_x: end_x.to_i,
        end_y: end_y.to_i,
        toggle?: TOGGLE == parts[0],
        on?: TURN == parts[0] && 'on' == parts[1],
        off?: TURN == parts[0] && 'off' == parts[1] 
      )
    end

    def adjust(command)
      (command.start_x..command.end_x).each do |x|
        (command.start_y..command.end_y).each do |y|
          @lights[x] ||= []

          light = @lights[x][y]

          if light.nil? && (command.toggle? || command.on?)
            @lights[x][y] = 1
          elsif light.present? && (command.toggle? || command.off?)
            @lights[x][y] = nil
          end
        end
      end
    end

    def adjust2(command)
      (command.start_x..command.end_x).each do |x|
        (command.start_y..command.end_y).each do |y|
          @lights[x] ||= []

          light = @lights[x][y] || 0

          @lights[x][y] = light + 1 if command.on?
          @lights[x][y] = light + 2 if command.toggle?
          @lights[x][y] = light - 1 if light.positive? && command.off?
        end
      end
    end

    def part1
      @lights = []

      @data.each do |command|
        adjust(command)
      end

      @lights
    end

    def part2
      @lights = []

      @data.each do |command|
        adjust2(command)
      end

      @lights
    end
  end
end
