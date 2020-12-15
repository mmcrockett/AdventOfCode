class String
  def red?
    self == 'red'
  end
end
  
module Y2015
  class Day12
    # 79443 too low
    include FileName

    def initialize(file: nil, file_ext: nil)
      @data = JSON.parse(File.read(file_name(file: file, file_ext: file_ext)))
    end

    def object_sum(data)
      return 0 if data.nil? || data.is_a?(String)
      return data if data.is_a?(Integer)

      sum = 0

      data.each {|k, v| sum += object_sum(k) + object_sum(v) } if data.is_a?(Hash)
      data.each {|v| sum += object_sum(v) } if data.is_a?(Array)

      sum
    end

    def part1
      object_sum(@data)
    end

    def object_sum_no_red(data)
      return 0 if data.nil? || data.is_a?(String)
      return data if data.is_a?(Integer)

      sum = 0

      if data.is_a?(Hash)
        return 0 if data.each_value.any? {|v| v.try(:red?) }
        data.each {|k, v| sum += object_sum_no_red(k) + object_sum_no_red(v) } if data.is_a?(Hash)
      else
        data.each {|v| sum += object_sum_no_red(v) } if data.is_a?(Array)
      end

      sum
    end


    def part2
      object_sum_no_red(@data)
    end
  end
end
