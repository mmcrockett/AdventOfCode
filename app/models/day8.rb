class Day8
  include FileName

  def initialize(file: nil, file_ext: nil)
    @data = load_data(file_name(file: file, file_ext: file_ext))
  end

  def load_data(file)
    File.open(file).each_line.map(&:chomp)
  end

  def part1
    gc = Computer.new.load(@data)

    while false == gc.seen?
      gc.mark_seen.step
    end

    gc.accumulator
  end

  def part2
    change_indices = @data.map.each_with_index {|v, i| i if v.split(' ').first.in?([Computer::JMP, Computer::NOP]) }.compact
    gc = Computer.new

    change_indices.each do |index|
      code = @data.map.each_with_index do |v, i|
        case index == i
        when true
          if v.include?(Computer::JMP)
            v.gsub(Computer::JMP, Computer::NOP) 
          elsif v.include?(Computer::NOP)
            v.gsub(Computer::NOP, Computer::JMP)
          else
            raise "not found #{v}"
          end
        when false
          v
        end
      end

      gc = Computer.new.load(code)

      while false == gc.seen? && false == gc.beyond_memory?
        gc.mark_seen.step
      end

      break if gc.beyond_memory? && gc.ip == code.size
    end

    gc.accumulator
  end
end
