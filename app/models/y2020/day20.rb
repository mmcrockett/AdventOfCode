module Y2020
  class Tile
    attr_reader :id, :connections, :d
    attr_accessor :x, :y

    def initialize(line)
      @id = line.match(/(?<id>\d+):/)['id'].to_i
      @d  = []
      @connections = Set.new
    end

    def placed?
      false == x.nil? && false == y.nil?
    end

    def <<(line)
      if line.is_a?(String)
        @d << line.chars
      else
        @d << line
      end
    end

    def to_s
      "#{@id} #{x} #{y}"
    end

    def edges
      build_edges if @edges.nil?
      @edges
    end

    def match?(other_tile)
      return false if other_tile.id == self.id
      other_tile.edges.any? {|other_edge| edges.include?(other_edge) }
    end

    def connect(other_tile)
      @connections << other_tile
    end

    def top
      @d[0].join
    end

    def bottom
      @d[-1].join
    end

    def left
      @d.map {|l| l[0]}.join
    end

    def right
      @d.map {|l| l[-1]}.join
    end

    def size
      @d.size
    end

    def rotate
      new_d = (0..size - 1).map do |i|
        @d.map {|line| line[i] }.reverse
      end

      @d = new_d

      puts "#{@id} Rotate"

      self
    end

    def flip
      @d = @d.reverse

      puts "#{@id} Flip"

      self
    end

    def connect_to(other_tile)
      raise "Can't combine unconnected tiles" unless self.connections.include?(other_tile)

      dirs = %i[top bottom left right].freeze

      dirs.each do |a_dir|
        dirs.each do |b_dir|
          new_dir = case a_dir
                    when :top
                      :bottom
                    when :left
                      :right
                    when :right
                      :left
                    when :bottom
                      :top
                    end

          if self.send(a_dir) == other_tile.send(b_dir)
            puts "Connect #{self} #{a_dir} to #{other_tile} #{b_dir}"

            case [a_dir, b_dir]
            when [:top, :bottom], [:bottom, :top], [:right, :left], [:left, :right]
              # All good
            when [:top, :top], [:bottom, :bottom]
              other_tile.flip
            when [:right, :right], [:left, :left]
              other_tile.flip.rotate.rotate
            when [:top, :left], [:bottom, :right]
              other_tile.rotate.rotate.rotate
            when [:left, :bottom], [:right, :top]
              other_tile.rotate.rotate.rotate.flip
            when [:top, :right], [:bottom, :left]
              other_tile.rotate.rotate.rotate.flip
            when [:left, :top], [:right, :bottom]
              other_tile.rotate
            end

            debugger unless self.send(a_dir) == other_tile.send(new_dir)
            raise 'wrong translation' unless self.send(a_dir) == other_tile.send(new_dir)

            return a_dir
          elsif self.send(a_dir) == other_tile.send(b_dir).reverse
            puts "Connect #{self} #{a_dir} to #{other_tile} #{b_dir} reversed"

            case [a_dir, b_dir]
            when [:right, :left], [:left, :right]
              other_tile.flip
            when [:top, :bottom], [:bottom, :top] 
              other_tile.flip.rotate.rotate
            when [:top, :top], [:bottom, :bottom], [:right, :right], [:left, :left]
              other_tile.rotate.rotate
            when [:top, :left], [:bottom, :right]
              other_tile.rotate.rotate.rotate.flip
            when [:left, :bottom], [:right, :top]
              other_tile.rotate.rotate.rotate
            when [:top, :right], [:bottom, :left]
              other_tile.rotate
            when [:left, :top], [:right, :bottom]
              other_tile.rotate.flip
            end

            debugger unless self.send(a_dir) == other_tile.send(new_dir)
            raise 'wrong translation' unless self.send(a_dir) == other_tile.send(new_dir)

            return a_dir
          end
        end
      end

      raise 'Tile not found'
    end

    def self.connect(tile_a, tile_b)
      tile_a.connect(tile_b)
      tile_b.connect(tile_a)
    end

    def display
      puts "#{@id}"
      @d.each do |line|
        puts line.join
      end

      nil
    end

    private
    def build_edges
      @edges = []
      @edges << self.top
      @edges << self.left
      @edges << self.bottom
      @edges << self.right

      @edges = @edges.map {|edge| [edge, edge.reverse] }.flatten
    end
  end

  class Day20
    include FileName

    def initialize(file: nil, file_ext: nil, preamble_size: 25)
      @tiles = []
      
      load_data(file_name(file: file, file_ext: file_ext)).each do |line|
        @tiles << Tile.new(line) if line.start_with?('Tile')
        @tiles[-1] << line unless line.start_with?('Tile') || line.empty?
      end
    end

    def part1
      tiles = @tiles.dup

      while false == tiles.empty?
        tile = tiles.shift

        tiles.each do |other_tile|
          Tile.connect(tile, other_tile) if tile.match?(other_tile)
        end
      end

      @tiles.select {|t| t.connections.size == 2 }.map(&:id).reduce(&:*)
    end

    def display_tiles(tiles: @tiles, summary: true, border: true)
      grouped = Hash[tiles.group_by(&:y).sort]

      grouped.each_value do |row|
        row = row.sort_by(&:x)

        if summary
          puts "#{row.map(&:id).join(' ')}"
        else
          (0..row.first.size - 1).each do |y_i|
            row.each {|tile| print(tile.d[y_i].join); print(' ') }
            puts
          end
          puts
        end
      end

      self
    end

    def assemble
      tile   = @tiles.first
      tile.x = 0
      tile.y = 0
      tiles  = [tile]

      while @tiles.any? {|t| false == t.placed? }
        tile = tiles.shift

        tile.connections.each do |other_tile|
          next if other_tile.placed?

          tiles << other_tile
          connected_side = tile.connect_to(other_tile)

          case connected_side
          when :top
            other_tile.x = tile.x
            other_tile.y = tile.y - 1
          when :bottom
            other_tile.x = tile.x
            other_tile.y = tile.y + 1
          when :left
            other_tile.x = tile.x - 1
            other_tile.y = tile.y
          when :right
            other_tile.x = tile.x + 1
            other_tile.y = tile.y
          end
          display_tiles(tiles: @tiles.select(&:placed?), summary: false)
          puts "#{@tiles.select(&:placed?).map(&:to_s)}"
        end
      end
    end

    def single_tile
      grouped = Hash[@tiles.group_by(&:y).sort]
      tile    = Tile.new('Tile 0000:')

      grouped.each_value.map do |row|
        row = row.sort_by(&:x)
        max = row.first.size - 2
          
        (1..max).each do |y_i|
          tile << row.map do |small_tile|
            small_tile.d[y_i][1..max]
          end.flatten
        end
      end

      tile
    end

    def debug_assemble
      [[1951, 2311, 3079],[2729, 1427, 2473], [2971, 1489, 1171]].each_with_index do |row, y|
        row.each_with_index do |tile_id, x|
          tile = @tiles.find {|stile| stile.id == tile_id }
          tile.flip if [1951, 2729, 1427].include?(tile_id)
          tile.rotate.flip if [2473].include?(tile_id)
          tile.flip if [2971, 2311, 1489].include?(tile_id)
          tile.flip.rotate.rotate if [1171].include?(tile_id)
          tile.x = x
          tile.y = y
        end
      end
    end

    def sea_monster(picture)
      sea_monster_found = false
      tries = 0

      while false == sea_monster_found && tries < 8
        picture.rotate if tries > 0
        picture.flip if 4 == tries

        tries += 1

        picture.display

        picture.d.each_with_index do |row, y|
          next unless y < (picture.d.size - 2)

          row.each_with_index do |square, x|
            next unless x > 17 && x < (row.size - 1) && '#' == square
            next unless '#' == picture.d[y + 1][x]
            next unless '#' == picture.d[y + 1][x + 1]
            next unless '#' == picture.d[y + 1][x - 1]
            next unless '#' == picture.d[y + 2][x - 2]

            next unless '#' == picture.d[y + 2][x - 5]
            next unless '#' == picture.d[y + 1][x - 6]
            next unless '#' == picture.d[y + 1][x - 7]
            next unless '#' == picture.d[y + 2][x - 8]

            next unless '#' == picture.d[y + 2][x - 11]
            next unless '#' == picture.d[y + 1][x - 12]
            next unless '#' == picture.d[y + 1][x - 13]
            next unless '#' == picture.d[y + 2][x - 14]

            next unless '#' == picture.d[y + 2][x - 17]
            next unless '#' == picture.d[y + 1][x - 18]

            sea_monster_found = true

            picture.d[y][x] = 'O'
            picture.d[y + 1][x] = 'O'
            picture.d[y + 1][x + 1] = 'O'
            picture.d[y + 1][x - 1] = 'O'
            picture.d[y + 2][x - 2] = 'O'
            picture.d[y + 2][x - 5] = 'O'
            picture.d[y + 1][x - 6] = 'O'
            picture.d[y + 1][x - 7] = 'O'
            picture.d[y + 2][x - 8] = 'O'
            picture.d[y + 2][x - 11] = 'O'
            picture.d[y + 1][x - 12] = 'O'
            picture.d[y + 1][x - 13] = 'O'
            picture.d[y + 2][x - 14] = 'O'
            picture.d[y + 2][x - 17] = 'O'
            picture.d[y + 1][x - 18] = 'O'
          end
        end
      end
    end

    def part2(debug = false)
      @debug = debug
      self.part1 if @tiles.first.connections.empty?

      case @debug
      when true
        self.debug_assemble
      when false
        tile = @tiles.find {|stile| stile.id == 1951 }
        @tiles.delete(tile)
        tile.flip
        @tiles.unshift(tile)
        self.assemble
      end

      display_tiles

      single_tile = self.single_tile

      sea_monster(single_tile)

      single_tile.d.flatten.select {|c| '#' == c }.size
    end
  end
end
