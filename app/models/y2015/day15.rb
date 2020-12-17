module Y2015
  # too high 240014016
  # too low p2 8350452
  class Day15
    include FileName

    def initialize(file: nil, file_ext: nil)
      @ingredients = Set.new
      @properties  = {}

      load_data(file_name(file: file, file_ext: file_ext)).each do |line|
        (ingredient, values) = line.split(':')

        values.split(',').each do |value|
          (prop, amount) = value.split(' ')

          @ingredients << ingredient
          @properties[prop]        ||= {}
          @properties[prop][ingredient]  = amount.to_i
        end
      end
    end

    def min(values, max: 100, min: 0)
      amt = (100.to_f / values.map(&:abs).sum)

      if values.size == 2
        return (amt * values.map(&:abs).min) + 1
      else
        raise 'missing for this size'
      end
    end

    def scoring_properties
      @scoring_properties ||= @properties.reject {|k, v| 'calories' == k }
    end

    def calorie_properties
      @calorie_properties ||= @properties.select {|k, v| 'calories' == k }
    end

    def score(ingredients)
      results = scoring_properties.map do |property, amounts|
        amounts.map {|k,v| v * ingredients[k] }.sum
      end

      return 0 if results.any?(&:negative?)

      results.reduce(&:*)
    end

    def calories(ingredients)
      results = calorie_properties.map do |property, amounts|
        amounts.map {|k,v| v * ingredients[k] }.sum
      end

      return 0 if results.any?(&:negative?)

      results.reduce(&:*)
    end

    def find_max_score(limits, amounts = {}, max: 100)
      @valid_combos ||= []

      ingredient = limits.first
      results    = 0

      if 1 < limits.size
        results = (ingredient[:min]..max).map do |i|
          new_amounts = amounts.merge({ingredient[:name] => i})

          find_max_score(limits[1..-1], new_amounts, max: max - i)
        end
      else
        new_amounts = amounts.merge({ingredient[:name] => max})

        results = score(new_amounts) if @calorie_limit.nil? || @calorie_limit == calories(new_amounts)

        @valid_combos << new_amounts if results.positive?
      end

      results
    end

    def mins
      return @mins unless @mins.nil?

      @mins  = Hash.new(0)

      scoring_properties.each do |prop, ingredients|
        filtered  = ingredients.reject {|name, value| value.zero? }
        groupings = filtered.group_by {|k,v| v.positive? }
        next if groupings.size == 1 || groupings[true].size != 1 || groupings[false].size != 1

        (p_ingredient, p_value) = groupings[true].first
        new_min = min(filtered.values).to_i

        if new_min > @mins[p_ingredient]
          @mins[p_ingredient] = new_min
        end
      end

      @mins
    end

    def part1
      find_max_score(@ingredients.map {|name| {name: name, min: mins[name]} }).flatten.max
    end

    def part2
      @calorie_limit = 500

      maxs  = Hash.new(100)
      valid_combos = []

      calorie_properties.each do |prop, ingredients|
        ingredients.each do |k, v|
          maxs[k] = 500 / v
          maxs[k] = 100 if maxs[k] > 100
        end
      end
  
      find_max_score(@ingredients.map {|name| {name: name, min: 0} }).flatten.max
    end
  end
end
