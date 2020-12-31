module Y2020
  class Day21
    include FileName

    def initialize(file: nil, file_ext: nil, preamble_size: 25)
      @data  = {}
      @recipes = []

      load_data(file_name(file: file, file_ext: file_ext)).each do |line|
        (foods, allergens) = line.split(/\(contains /)
        foods = foods.split(' ')

        @recipes << foods

        allergens.split(/, /).each do |allergen|
          @data[allergen.delete(')')] ||= []
          @data[allergen.delete(')')] << foods
        end
      end
    end

    def results
      data = Hash[@data.map {|k,v| [k, v.reduce(&:&)] }]

      while false == data.select {|k, v| v.is_a?(Array) }.empty?
        data = Hash[data.map {|k,v| [k, v.size == 1 ? v[0] : v] }]

        found = data.reject {|k, v| v.is_a?(Array) }

        found.each do |allergen, food|
          data = Hash[data.map do |k, v|
            v.delete(food)
            [k, v]
          end]
        end
      end

      data
    end

    def part1
      ingredients = @recipes.flatten

      results.values.each do |allergen_food|
        ingredients.delete(allergen_food)
      end

      ingredients.size
    end

    def part2
      Hash[results.sort_by {|k,v| k }].values.join(',')
    end
  end
end
