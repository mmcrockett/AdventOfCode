module Y2020
  class Day14
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = load_data(file_name(file: file, file_ext: file_ext))
    end

    def or_mask(mask)
      mask.chars.map {|c| '1' == c ? 1 : 0 }.join.to_i(2)
    end

    def and_mask(mask)
      mask.chars.map {|c| '0' == c ? 0 : 1 }.join.to_i(2)
    end

    def x_mask(mask)
      and_mask = mask.chars.map {|c| 'X' == c ? 0 : 1 }.join.to_i(2)
      or_mask  = mask.chars.reverse.map.each_with_index {|c, i| i if 'X' == c }.compact
      or_masks = [0]

      (1..or_mask.size).each do |i|
        or_mask.combination(i).each do |combo|
          new_mask = 0

          combo.each do |lshift|
            new_mask |= 1 << lshift
          end

          or_masks << new_mask
        end
      end

      OpenStruct.new(
        and_mask: and_mask,
        or_masks: or_masks
      )
    end

    def parse(instruction)
      parts = instruction.split(/(\d+)/)
      OpenStruct.new(
        location: parts[1].to_i,
        value: parts[-1].to_i
      )
    end

    def part1
      memory = {}
      mask   = nil
      omask  = nil
      amask  = nil

      @data.each do |instruction|
        if instruction.start_with?('mask')
          mask  = instruction.chars.select {|c| ['1', '0', 'X'].include?(c) }.join
          omask = or_mask(mask)
          amask = and_mask(mask)
        else
          instruction = parse(instruction)
          memory[instruction.location] = (instruction.value & amask) | omask
        end
      end

      memory
    end

    def part2
      memory = {}
      mask   = nil
      omask  = nil
      xmask  = nil

      @data.each do |instruction|
        if instruction.start_with?('mask')
          mask  = instruction.chars.select {|c| ['1', '0', 'X'].include?(c) }.join
          omask = or_mask(mask)
          xmask = x_mask(mask)
        else
          instruction = parse(instruction)
          memory_loc  = instruction.location | omask
          memory_loc &= xmask.and_mask

          xmask.or_masks.each do |xmask_or|
            temp_loc = memory_loc | xmask_or

            memory[temp_loc] = instruction.value
          end
        end
      end

      memory
    end
  end
end
