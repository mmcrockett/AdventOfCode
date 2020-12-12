class WaypointShip
  def initialize
    @waypoint = OpenStruct.new(east: 10, north: 1)
    @coords   = OpenStruct.new(east: 0, north: 0)
  end

  def perform(instruction)
    instruction = Ship.parse(instruction)
    command     = instruction.command

    case command
    when Ship::NORTH
      @waypoint.north += instruction.value
    when Ship::SOUTH
      @waypoint.north -= instruction.value
    when Ship::EAST
      @waypoint.east += instruction.value
    when Ship::WEST
      @waypoint.east -= instruction.value
    when Ship::FORWARD
      @coords.east  += (@waypoint.east  * instruction.value)
      @coords.north += (@waypoint.north * instruction.value)
    when Ship::LEFT, Ship::RIGHT
      rotations = (instruction.value / 90) % Ship::HEADINGS.size
      rotations = (Ship::HEADINGS.size - rotations) if Ship::LEFT == command

      case rotations
      when 1
        old_east = @waypoint.east

        @waypoint.east  = @waypoint.north
        @waypoint.north = -old_east
      when 2
        @waypoint.east  = -@waypoint.east
        @waypoint.north = -@waypoint.north
      when 3
        old_east = @waypoint.east

        @waypoint.east  = -@waypoint.north
        @waypoint.north = old_east
      end
    end
  end

  def distance
    Ship.distance(@coords)
  end
end

class Ship
  LEFT  = 'L'.freeze
  RIGHT = 'R'.freeze
  FORWARD = 'F'.freeze

  NORTH = 'N'.freeze
  SOUTH = 'S'.freeze
  EAST  = 'E'.freeze
  WEST  = 'W'.freeze

  HEADINGS = [
    NORTH,
    WEST,
    SOUTH,
    EAST
  ].freeze

  ALL_COMMANDS = [
    NORTH,
    SOUTH,
    EAST,
    WEST,
    LEFT,
    RIGHT,
    FORWARD
  ].freeze

  def initialize(heading = Ship::EAST)
    @heading_i = HEADINGS.index(heading)
    @coords    = OpenStruct.new(latitude: 0, longitude: 0)
  end

  def heading
    HEADINGS[@heading_i]
  end

  def perform(instruction)
    instruction = Ship.parse(instruction)
    command     = instruction.command
    command     = heading if FORWARD == command

    case command
    when NORTH
      @coords.latitude += instruction.value
    when SOUTH
      @coords.latitude -= instruction.value
    when EAST
      @coords.longitude += instruction.value
    when WEST
      @coords.longitude -= instruction.value
    when LEFT, RIGHT
      rotation = (instruction.value / 90)
      rotation = -rotation if RIGHT == command

      @heading_i = (@heading_i + rotation) % HEADINGS.size
    end
  end

  def self.parse(instruction)
    matcher = instruction.match(/(?<command>#{ALL_COMMANDS.join('|')}{1})(?<value>\d+)/)

    raise "Error on match #{instruction}" if matcher.nil?

    OpenStruct.new(
      command: matcher['command'],
      value: matcher['value'].to_i
    )
  end

  def distance
    Ship.distance(@coords)
  end

  def self.distance(coords)
    coords.to_h.each_value.map(&:abs).sum
  end
end

class Day12
  include FileName

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext))
  end

  def part1
    ship = Ship.new

    @data.each do |instruction|
      ship.perform(instruction)
    end

    ship
  end

  def part2
    ship = WaypointShip.new

    @data.each do |instruction|
      ship.perform(instruction)
    end

    ship
  end
end
