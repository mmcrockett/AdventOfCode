# frozen_string_literal: true

module Year2022
  class Day07 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file
    MIN = 100_000
    TOTAL_DISK = 70_000_000
    NEEDED_DISK = 30_000_000

    class Directory
      attr_reader :name, :parent, :dirs

      def initialize(name, parent = nil)
        @name = name
        @files = {}
        @dirs  = {}
        @parent = parent
        @size = nil
      end

      def [](name)
        @dirs[name] or raise "#{name} not found"
      end

      def <<(line)
        (f, l) = line.split

        case f
        when 'dir'
          @dirs[l] ||= Directory.new(l, self)
        else
          @files[l] = f.to_i
        end
      end

      def size
        @size ||= @files.values.sum + @dirs.values.map(&:size).sum
      end
    end

    def part_1
      home = Directory.new('home')
      curr = nil
      directories = [home]
      size = 0

      data.each do |line|
        if line.start_with?('$')
          if line.include?('cd')
            (_a, _b, where_to) = line.split

            curr = case where_to
                   when '/'
                     home
                   when '..'
                     curr.parent
                   else
                     curr[where_to]
                   end
          end
        else
          curr << line
        end
      end

      while false == directories.empty?
        dir = directories.shift
        directories << dir.dirs.values
        directories.flatten!
        size += dir.size if dir.size <= MIN
      end

      size
    end

    def part_2
      home = Directory.new('home')
      curr = nil
      directories = [home]
      sizes = []

      data.each do |line|
        if line.start_with?('$')
          if line.include?('cd')
            (_a, _b, where_to) = line.split

            curr = case where_to
                   when '/'
                     home
                   when '..'
                     curr.parent
                   else
                     curr[where_to]
                   end
          end
        else
          curr << line
        end
      end

      while false == directories.empty?
        dir = directories.shift
        directories << dir.dirs.values
        directories.flatten!
        sizes << dir.size
      end

      used = TOTAL_DISK - home.size
      needed = NEEDED_DISK - used

      sizes.sort.find { |size| size > needed }
    end

    # Processes each line of the input file and stores the result in the dataset
    # def process_input(line)
    #   line.map(&:to_i)
    # end

    # Processes the dataset as a whole
    # def process_dataset(set)
    #   set
    # end
  end
end
