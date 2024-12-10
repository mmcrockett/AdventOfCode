require "test_helper"

class Day20Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{name.underscore}.txt"

  def parse_map(input)
    portals  = {}
    map      = []
    top_left    = []
    bot_right   = []

    input.each_with_index do |line, y|
      row = []
      line.each_with_index do |tile, x|
        if tile.opening?
          key = nil

          if input_data[y + 1][x].portal?
            key = input[y + 1][x].chr + input[y + 2][x].chr
          elsif input[y - 1][x].portal?
            key = input[y - 2][x].chr + input[y - 1][x].chr
          elsif input[y][x + 1].portal?
            key = input[y][x + 1].chr + input[y][x + 2].chr
          elsif input[y][x - 1].portal?
            key = input[y][x - 2].chr + input[y][x - 1].chr
          end

          if key.present?
            if portals.include?(key)
              portals[key + "x"] = Dijkstra::Node.new(key + "x", x: x, y: y)
            else
              portals[key] = Dijkstra::Node.new(key, x: x, y: y)
            end

            row << if "AA" == key
                     "S".ord
            elsif "ZZ" == key
                     "F".ord
            else
                     "P".ord
            end
          else
            row << tile
          end
        else
          row << "#".ord
        end

        if top_left.empty? && tile.wall?
          top_left = [ x, y ]
        elsif tile.wall?
          bot_right = [ x, y ]
        end
      end

      map << row
    end

    portals.each do |k, v|
      v.z = if %w[AA ZZ].include?(k)
              0
      elsif v.x > top_left.first && v.y > top_left.last && v.x < bot_right.first && v.y < bot_right.last
              1
      else
              -1
      end
    end

    [ portals, map ]
  end

  def bfs(portals, map)
    edges = []

    portals.each do |_name, node|
      queue = [ node.coord ]
      distance = { node.coord => 0 }

      while false == queue.empty?
        from_x, from_y = queue.shift
        [ [ 0, -1 ], [ 0, 1 ], [ -1, 0 ], [ 1, 0 ] ].each do |delta_x, delta_y|
          x = from_x + delta_x
          y = from_y + delta_y
          pos  = [ x, y ]
          tile = map[y][x]

          next if tile.wall? || distance.include?(pos)

          distance[pos] = distance[[ from_x, from_y ]] + 1

          if tile.portal?
            other_node = portals.find { |_k, v| v.coord == pos }.last

            raise if other_node.nil?

            edges << [ node, other_node, distance[pos] ]
          end

          queue << [ x, y ]
        end
      end
    end

    edges
  end

  describe "part 1" do
    let(:answer) do
      (portals, map) = parse_map(input_data)
      edges = bfs(portals, map)
      portals.values.group_by do |node|
        node.name.delete("x")
      end.each do |pairs|
        if 2 == pairs.last.size
          edges << [ pairs.last[0],
                    pairs.last[1], 1 ]
        end
      end
      edges.each do |n0, n1, d|
        n0.add_neighbor(n1, d)
        n1.add_neighbor(n0, d)
      end

      Dijkstra::ShortestPath.new(portals.values, portals["AA"]).shortest_distance_to(portals["ZZ"])
    end

    describe "example 0" do
      let(:data) { p1_e0 }

      it "works" do
        assert_equal(23, answer)
      end
    end

    describe "example 1" do
      let(:data) { p1_e1 }

      it "works" do
        assert_equal(58, answer)
      end
    end

    describe "solution" do
      let(:data) { puzzle }

      it "works" do
        assert_equal(676, answer)
      end
    end
  end

  describe "part 2" do
    def bfs2(portals, map)
      start = portals.delete("AA")
      portals.delete("ZZ")

      (start + portals.values).each do |node|
        queue = [ node.coord ]
        distance = { node.coord => 0 }

        while false == queue.empty?
          from_x, from_y = queue.shift

          [ [ 0, -1 ], [ 0, 1 ], [ -1, 0 ], [ 1, 0 ] ].each do |delta_x, delta_y|
            x = from_x + delta_x
            y = from_y + delta_y
            pos  = [ x, y ]
            tile = map[y][x]

            next if tile.wall? || distance.include?(pos)

            distance[pos] = distance[[ from_x, from_y ]] + 1

            if tile.portal?
              other_node = portals.find { |_k, v| v.coord == pos }.last

              raise if other_node.nil?

              edges << [ node, other_node, distance[pos] ]
            end

            queue << [ x, y ]
          end
        end
      end

      edges
    end

    let(:answer) do
      (portals, map) = parse_map(input_data)
      edges = bfs(portals, map)
      portals.values.group_by do |node|
        node.name.delete("x")
      end.each do |pairs|
        if 2 == pairs.last.size
          edges << [ pairs.last[0],
                    pairs.last[1], 1 ]
        end
      end
      edges.each do |n0, n1, d|
        n0.add_neighbor(n1, d)
        n1.add_neighbor(n0, d)
      end

      start = portals["AA"]
      portals["ZZ"]
      queue  = []
      found  = {}

      queue << start
      found[start] = true

      queue.shift while queue.any?

      11
    end

    describe "p1 example" do
      let(:data) { p1_e0 }

      it "works" do
        skip
        assert_equal(26, answer)
      end
    end

    describe "example 0" do
      let(:data) { p2_e0 }

      it "works" do
        skip
        assert_equal(396, answer)
      end
    end

    describe "solution" do
      let(:data) { puzzle }

      it "works" do
        skip
      end
    end
  end

  let(:p1_e0) do
    <<~STR
               A#{'           '}
               A#{'           '}
        #######.##########{'  '}
        #######.........##{'  '}
        #######.#######.##{'  '}
        #######.#######.##{'  '}
        #######.#######.##{'  '}
        #####  B    ###.##{'  '}
      BC...##  C    ###.##{'  '}
        ##.##       ###.##{'  '}
        ##...DE  F  ###.##{'  '}
        #####    G  ###.##{'  '}
        #########.#####.##{'  '}
      DE..#######...###.##{'  '}
        #.#########.###.##{'  '}
      FG..#########.....##{'  '}
        ###########.######{'  '}
                   Z#{'       '}
                   Z#{'      '}
    STR
  end

  let(:p1_e1) do
    <<~STR
                         A#{'               '}
                         A#{'               '}
        #################.##############{'  '}
        #.#...#...................#.#.##{'  '}
        #.#.#.###.###.###.#########.#.##{'  '}
        #.#.#.......#...#.....#.#.#...##{'  '}
        #.#########.###.#####.#.#.###.##{'  '}
        #.............#.#.....#.......##{'  '}
        ###.###########.###.#####.#.#.##{'  '}
        #.....#        A   C    #.#.#.##{'  '}
        #######        S   P    #####.##{'  '}
        #.#...#                 #......VT
        #.#.#.#                 #.######{'  '}
        #...#.#               YN....#.##{'  '}
        #.###.#                 #####.##{'  '}
      DI....#.#                 #.....##{'  '}
        #####.#                 #.###.##{'  '}
      ZZ......#               QG....#..AS
        ###.###                 ########{'  '}
      JO..#.#.#                 #.....##{'  '}
        #.#.#.#                 ###.#.##{'  '}
        #...#..DI             BU....#..LF
        #####.#                 #.######{'  '}
      YN......#               VT..#....QG
        #.###.#                 #.###.##{'  '}
        #.#...#                 #.....##{'  '}
        ###.###    J L     J    #.#.####{'  '}
        #.....#    O F     P    #.#...##{'  '}
        #.###.#####.#.#####.#####.###.##{'  '}
        #...#.#.#...#.....#.....#.#...##{'  '}
        #.#####.###.###.#.#.#########.##{'  '}
        #...#.#.....#...#.#.#.#.....#.##{'  '}
        #.###.#####.###.###.#.#.########{'  '}
        #.#.........#...#.............##{'  '}
        #########.###.###.##############{'  '}
                 B   J   C#{'               '}
                 U   P   P#{'               '}
    STR
  end
  let(:p2_e0) do
    <<~STR
                   Z L X W       C#{'                 '}
                   Z P Q B       K#{'                 '}
        ###########.#.#.#.#######.################{'  '}
        #...#.......#.#.......#.#.......#.#.#...##{'  '}
        ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.####{'  '}
        #.#...#.#.#...#.#.#...#...#...#.#.......##{'  '}
        #.###.#######.###.###.#.###.###.#.########{'  '}
        #...#.......#.#...#...#.............#...##{'  '}
        #.#########.#######.#.#######.#######.####{'  '}
        #...#.#    F       R I       Z    #.#.#.##{'  '}
        #.###.#    D       E C       H    #.#.#.##{'  '}
        #.#...#                           #...#.##{'  '}
        #.###.#                           #.###.##{'  '}
        #.#....OA                       WB..#.#..ZH
        #.###.#                           #.#.#.##{'  '}
      CJ......#                           #.....##{'  '}
        #######                           ########{'  '}
        #.#....CK                         #......IC
        #.###.#                           #.###.##{'  '}
        #.....#                           #...#.##{'  '}
        ###.###                           #.#.#.##{'  '}
      XF....#.#                         RF..#.#.##{'  '}
        #####.#                           ########{'  '}
        #......CJ                       NM..#...##{'  '}
        ###.#.#                           #.###.##{'  '}
      RE....#.#                           #......RF
        ###.###        X   X       L      #.#.#.##{'  '}
        #.....#        F   Q       P      #.#.#.##{'  '}
        ###.###########.###.#######.#########.####{'  '}
        #.....#...#.....#.......#...#.....#.#...##{'  '}
        #####.#.###.#######.#######.###.###.#.#.##{'  '}
        #.......#.......#.#.#.#.#...#...#...#.#.##{'  '}
        #####.###.#####.#.#.#.#.###.###.#.###.####{'  '}
        #.......#.....#.#...#...............#...##{'  '}
        #############.#.#.###.####################{'  '}
                     A O F   N#{'                     '}
                     A A D   M#{'                     '}
    STR
  end
  let(:puzzle) { read_test_file(File.join("aoc", PUZZLE_FILE)) }
  let(:input_data) { data.lines.map { |line| line.chomp.chars.map(&:ord) } }
end
