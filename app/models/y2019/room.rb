class Room
  attr_reader :name, :items, :notes

  def initialize(from_command: nil, room_data:)
    parse_room_data(room_data)

    if from_command.present?
      @go_back_command  = from_command.opposite
      @visited.delete(@go_back_command)
    end
  end

  def next
    @visited.find {|k,v| false == v}.first
  end

  def next?
    @visited.any? {|k,v| false == v}
  end

  def visited!(direction)
    @visited[direction] = true
  end

  def go_back
    @go_back_command
  end

  def to_s
    "#{name} - #{notes} with #{@items}"
  end

  private
  def parse_room_data(data)
    @items   = []
    @notes   = '?'
    @name    = '?'
    @visited = {}

    lines    = data.split("\n")

    while lines.any?
      line = lines.shift

      if line.start_with?('== ')
        @name  = line.gsub('==', '').strip
        @notes = lines.shift.strip
      elsif line.start_with?('Doors here lead')
        line = lines.shift.gsub('-', '').strip

        while line.present?
          @visited[line] = false

          line = lines.shift.gsub('-', '').strip
        end
      elsif line.start_with?('Items here')
        line = lines.shift.gsub('-', '').strip

        while line.present?
          @items << line

          line = lines.shift.gsub('-', '').strip
        end
      elsif line.start_with?("You can't go that way.")
        debugger
        raise "Bad direction."
      end
    end
  end
end
