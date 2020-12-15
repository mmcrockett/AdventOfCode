require 'test_helper'

class Day20Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

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
              portals[key + 'x'] = Dijkstra::Node.new(key + 'x', x: x, y: y)
            else
              portals[key] = Dijkstra::Node.new(key, x: x, y: y)
            end

            if ('AA' == key)
              row << 'S'.ord
            elsif ('ZZ' == key)
              row << 'F'.ord
            else
              row << 'P'.ord
            end
          else
            row << tile
          end
        else
          row << '#'.ord
        end

        if top_left.empty? && tile.wall?
          top_left = [x, y]
        elsif tile.wall?
          bot_right = [x, y]
        end
      end

      map << row
    end

    portals.each do |k, v|
      if ['AA', 'ZZ'].include?(k)
        v.z = 0
      elsif v.x > top_left.first && v.y > top_left.last && v.x < bot_right.first && v.y < bot_right.last
        v.z = 1
      else
        v.z = -1
      end
    end

    return [portals, map]
  end

  def bfs(portals, map)
    edges = []

    portals.each do |name, node|
      queue = [ node.coord ]
      distance = { node.coord => 0 }

      while(false == queue.empty?)
        from_x, from_y = queue.shift
        [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |delta_x, delta_y|
          x = from_x + delta_x
          y = from_y + delta_y
          pos  = [x,y]
          tile = map[y][x]

          next if tile.wall? || distance.include?(pos)

          distance[pos] = distance[[from_x,from_y]] + 1

          if tile.portal?
            other_node = portals.find {|k,v| v.coord == pos}.last

            raise if other_node.nil?

            edges << [node, other_node, distance[pos]]
          end

          queue << [x, y]
        end
      end
    end

    return edges
  end

  describe 'part 1' do
    let(:answer) {
      (portals, map) = parse_map(input_data)
      edges  = bfs(portals, map)
      portals.values.group_by {|node| node.name.delete('x')}.each {|pairs| edges << [pairs.last[0], pairs.last[1], 1] if 2 == pairs.last.size }
      edges.each {|n0, n1, d| n0.add_neighbor(n1, d); n1.add_neighbor(n0, d) }

      Dijkstra::ShortestPath.new(portals.values, portals['AA']).shortest_distance_to(portals['ZZ'])
    }

    describe 'example 0' do
      let(:data) { p1_e0 }

      it 'works' do
        assert_equal(23, answer)
      end
    end

    describe 'example 1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal(58, answer)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(676, answer)
      end
    end
  end

  describe 'part 2' do
    def bfs2(portals, map)
      start  = portals.delete('AA')
      finish = portals.delete('ZZ')
      paths  = []

      (start + portals.values).each do |node|
        queue = [ node.coord ]
        distance = { node.coord => 0 }

        while (false == queue.empty?)
          from_x, from_y = queue.shift

          [[0, -1], [0, 1], [-1, 0], [1, 0]].each do |delta_x, delta_y|
            x = from_x + delta_x
            y = from_y + delta_y
            pos  = [x,y]
            tile = map[y][x]

            next if tile.wall? || distance.include?(pos)

            distance[pos] = distance[[from_x,from_y]] + 1

            if tile.portal?
              other_node = portals.find {|k,v| v.coord == pos}.last

              raise if other_node.nil?

              edges << [node, other_node, distance[pos]]
            end

            queue << [x, y]
          end
        end
      end

      return edges
    end

    let(:answer) {
      (portals, map) = parse_map(input_data)
      edges  = bfs(portals, map)
      portals.values.group_by {|node| node.name.delete('x')}.each {|pairs| edges << [pairs.last[0], pairs.last[1], 1] if 2 == pairs.last.size }
      edges.each {|n0, n1, d| n0.add_neighbor(n1, d); n1.add_neighbor(n0, d) }

      p = []
      counts = {}

      start  = portals['AA']
      finish = portals['ZZ']
      queue  = []
      found  = {}

      queue  << start
      found[start] = true

      while queue.any?
        v = queue.shift
      end

      11
    }

    describe 'p1 example' do
      let(:data) { p1_e0 }

      it 'works' do
        skip
        assert_equal(26, answer)
      end
    end

    describe 'example 0' do
      let(:data) { p2_e0 }

      it 'works' do
        skip
        assert_equal(396, answer)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        skip
      end
    end
  end

  let(:p1_e0) {
    <<-STR
         A           
         A           
  #######.#########  
  #######.........#  
  #######.#######.#  
  #######.#######.#  
  #######.#######.#  
  #####  B    ###.#  
BC...##  C    ###.#  
  ##.##       ###.#  
  ##...DE  F  ###.#  
  #####    G  ###.#  
  #########.#####.#  
DE..#######...###.#  
  #.#########.###.#  
FG..#########.....#  
  ###########.#####  
             Z       
             Z      
    STR
  }

  let(:p1_e1) {
    <<-STR
                   A               
                   A               
  #################.#############  
  #.#...#...................#.#.#  
  #.#.#.###.###.###.#########.#.#  
  #.#.#.......#...#.....#.#.#...#  
  #.#########.###.#####.#.#.###.#  
  #.............#.#.....#.......#  
  ###.###########.###.#####.#.#.#  
  #.....#        A   C    #.#.#.#  
  #######        S   P    #####.#  
  #.#...#                 #......VT
  #.#.#.#                 #.#####  
  #...#.#               YN....#.#  
  #.###.#                 #####.#  
DI....#.#                 #.....#  
  #####.#                 #.###.#  
ZZ......#               QG....#..AS
  ###.###                 #######  
JO..#.#.#                 #.....#  
  #.#.#.#                 ###.#.#  
  #...#..DI             BU....#..LF
  #####.#                 #.#####  
YN......#               VT..#....QG
  #.###.#                 #.###.#  
  #.#...#                 #.....#  
  ###.###    J L     J    #.#.###  
  #.....#    O F     P    #.#...#  
  #.###.#####.#.#####.#####.###.#  
  #...#.#.#...#.....#.....#.#...#  
  #.#####.###.###.#.#.#########.#  
  #...#.#.....#...#.#.#.#.....#.#  
  #.###.#####.###.###.#.#.#######  
  #.#.........#...#.............#  
  #########.###.###.#############  
           B   J   C               
           U   P   P               
    STR
  }
  let(:p2_e0) {
    <<-STR
             Z L X W       C                 
             Z P Q B       K                 
  ###########.#.#.#.#######.###############  
  #...#.......#.#.......#.#.......#.#.#...#  
  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###  
  #.#...#.#.#...#.#.#...#...#...#.#.......#  
  #.###.#######.###.###.#.###.###.#.#######  
  #...#.......#.#...#...#.............#...#  
  #.#########.#######.#.#######.#######.###  
  #...#.#    F       R I       Z    #.#.#.#  
  #.###.#    D       E C       H    #.#.#.#  
  #.#...#                           #...#.#  
  #.###.#                           #.###.#  
  #.#....OA                       WB..#.#..ZH
  #.###.#                           #.#.#.#  
CJ......#                           #.....#  
  #######                           #######  
  #.#....CK                         #......IC
  #.###.#                           #.###.#  
  #.....#                           #...#.#  
  ###.###                           #.#.#.#  
XF....#.#                         RF..#.#.#  
  #####.#                           #######  
  #......CJ                       NM..#...#  
  ###.#.#                           #.###.#  
RE....#.#                           #......RF
  ###.###        X   X       L      #.#.#.#  
  #.....#        F   Q       P      #.#.#.#  
  ###.###########.###.#######.#########.###  
  #.....#...#.....#.......#...#.....#.#...#  
  #####.#.###.#######.#######.###.###.#.#.#  
  #.......#.......#.#.#.#.#...#...#...#.#.#  
  #####.###.#####.#.#.#.#.###.###.#.###.###  
  #.......#.....#.#...#...............#...#  
  #############.#.#.###.###################  
               A O F   N                     
               A A D   M                     
  STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.lines.map {|line| line.chomp.chars.map(&:ord) } }
end
