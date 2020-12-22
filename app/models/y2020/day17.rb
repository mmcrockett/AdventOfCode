module Y2020
  class Day17
    # 258 too high part1
    ACTIVE   = '#'
    INACTIVE = '.'

    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = []

      @data << load_data(file_name(file: file, file_ext: file_ext)).map {|line| line.chars }
    end

    def cube_state(grid, x:, y:, z:)
      return INACTIVE if z < 0 || y < 0 || x < 0 || z >= grid.size || y >= grid[z].size || x >= grid[z][y].size
      grid[z][y][x]
    end

    def cube_state_w(grid, x:, y:, z:, w:)
      return INACTIVE if w < 0 || z < 0 || y < 0 || x < 0 || w >= grid.size || z >= grid[w].size || y >= grid[w][z].size || x >= grid[w][z][y].size
      grid[w][z][y][x]
    end

    def next_state(grid, x:, y:, z:)
      c_state = cube_state(grid, x: x, y: y, z: z)

      counts  = {ACTIVE => 0, INACTIVE => 0}

      (-1..1).each do |zn|
        #next if (zn + z) < 0
        (-1..1).each do |yn|
          #next if (yn + y) < 0
          (-1..1).each do |xn|
            #next if (xn + x) < 0
            next if zn.zero? && yn.zero? && xn.zero?

            counts[cube_state(grid, x: x + xn, y: y + yn, z: z + zn)] += 1
            #puts "#{z + zn},#{y + yn}, #{x + xn} #{counts[ACTIVE]}" if x == 0 && y == 0 && z == 0 && @skip.nil?

            return INACTIVE if counts[ACTIVE] > 3
          end
        end
      end

      #puts "#{z},#{y},#{x}:#{c_state} : #{counts[ACTIVE]}" if x >= 0 && y >= 0 && z == 0

      case c_state
      when ACTIVE
        return ACTIVE if [2, 3].include?(counts[ACTIVE])
      when INACTIVE
        return ACTIVE if 3 == counts[ACTIVE]
      end

      return INACTIVE
    end

    def next_state_w(grid, x:, y:, z:, w:)
      c_state = cube_state_w(grid, x: x, y: y, z: z, w: w)

      counts  = {ACTIVE => 0, INACTIVE => 0}

      (-1..1).each do |wn|
        (-1..1).each do |zn|
          (-1..1).each do |yn|
            (-1..1).each do |xn|
              next if zn.zero? && yn.zero? && xn.zero? && wn.zero?

              counts[cube_state_w(grid, x: x + xn, y: y + yn, z: z + zn, w: w + wn)] += 1

              return INACTIVE if counts[ACTIVE] > 3
            end
          end
        end
      end

      case c_state
      when ACTIVE
        return ACTIVE if [2, 3].include?(counts[ACTIVE])
      when INACTIVE
        return ACTIVE if 3 == counts[ACTIVE]
      end

      return INACTIVE
    end

    def display(grid)
      z_size = grid.size
      y_size = grid.first.size
      x_size = grid.first.first.size

      z_size.times do |z|
        puts "zzzz #{z} zzzz"
        y_size.times do |y|
          x_size.times do |x|
            print grid[z][y][x]
          end
          puts ''
        end
      end
    end

    def part1(n = 1)
      grids = [@data.dup]

      n.times do |i|
        c_grid   = grids[-1]
        z_size   = c_grid.size
        y_size   = c_grid.first.size
        x_size   = c_grid.first.first.size

        new_grid = Array.new(z_size + 2) { Array.new(y_size + 2) { Array.new(x_size + 2) { INACTIVE } } }

        (-1..z_size).each do |z|
          (-1..y_size).each do |y|
            (-1..x_size).each do |x|
              new_grid[z + 1][y + 1][x + 1] = next_state(c_grid, x: x, y: y, z: z)
            end
          end
        end

        grids << new_grid
      end

      grids
    end

    def part2(n = 1)
      grids = [@data.dup]

      n.times do |i|
        c_grid   = grids[-1]
        w_size   = c_grid.size
        z_size   = c_grid.first.size
        y_size   = c_grid.first.first.size
        x_size   = c_grid.first.first.first.size

        new_grid = Array.new(w_size + 2) { Array.new(z_size + 2) { Array.new(y_size + 2) { Array.new(x_size + 2) { INACTIVE } } } }

        (-1..w_size).each do |w|
          (-1..z_size).each do |z|
            (-1..y_size).each do |y|
              (-1..x_size).each do |x|
                new_grid[w + 1][z + 1][y + 1][x + 1] = next_state_w(c_grid, x: x, y: y, z: z, w: w)
              end
            end
          end
        end

        grids << new_grid
      end

      grids
    end
  end
end
