module Y2020
  class Day7
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext))
    end

    def load_data(file)
      bags   = {}

      File.open(file).each_line.map(&:chomp).each do |line|
        line = line.gsub('bags', '').gsub('bag', '').gsub(' .', '')

        (outer_bag, other_bags) = line.split(' contain ')

        outer_bag = parse(outer_bag).last

        raise "Duplicate bags #{outer_bag}" if bags.include?(outer_bag)

        bags[outer_bag] = []

        next if other_bags.include?('no other')

        other_bags.split(',').each do |part|
          bags[outer_bag] << parse(part)
        end
      end

      puts "#{bags}"

      bags
    end

    def parse(bag_data)
      values = bag_data.strip.split(' ')

      values.unshift(1) unless "#{values.first.to_i}" == values.first

      [values.shift.to_i, values.join('_')]
    end

    def deep_contains?(contents)
      contents.each do |other_bag|
        return true if 'shiny_gold' == other_bag.last

        return true if deep_contains?(@data[other_bag.last])
      end

      false
    end

    def deep_count(contents)
      count = 0

      contents.each do |other_bag|
        if @data[other_bag.last].blank?
          count += other_bag.first
        else
          count += other_bag.first + other_bag.first * deep_count(@data[other_bag.last])
        end
      end

      count
    end

    def part1
      useful_bags = []

      @data.each do |bag, contents|
        next if contents.empty?

        useful_bags << bag if deep_contains?(contents)
      end

      useful_bags
    end

    def part2
      deep_count(@data['shiny_gold'])
    end
  end
end
