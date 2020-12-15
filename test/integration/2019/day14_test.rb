require 'test_helper'

class Day14Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"
  GET_ORE = ->(input_data, fuel_needed = 1) {
      inputs_remaining = {}

      input_data.values.each do |inputs|
        inputs.each do |x|
          inputs_remaining[x.name] ||= 0
          inputs_remaining[x.name]  += 1
        end
      end

      needed    = {
        'FUEL' => fuel_needed
      }
      in_stock = {
      }
      ores = []
      simple    = input_data.select {|k,v| 1 == v.size && 'ORE' != v.first.name}.map {|k,v| k.name}
      elemental = input_data.select {|k,v| 'ORE' == v.first.name}.map {|k,v| k.name}

      puts '' if @debug

      while false == needed.reject {|k,v| 'ORE' == k}.empty?
        needed = Hash[needed.sort_by {|k,v| (elemental.include?(k) ? 100 : 0) + (simple.include?(k) ? 10 : 0) + inputs_remaining[k].to_i }]
        need = needed.shift

        puts "Need '#{need}'" if @debug

        output = input_data.select {|k,v| need.first == k.name }

        if 1 != output.size
          raise "Wrong number found '#{need}' '#{output}'"
        end

        puts "\tFound '#{output.keys}'" if @debug
        puts "\t\tIt needs '#{need.last}' * '#{output.values}'" if @debug

        output.each do |k,v|
          output_amt_multiple = ((need.last - in_stock[need.first].to_i).to_f / k.count).ceil

          v.each do |input|
            input_amt = output_amt_multiple * input.count

            if ('ORE' == input.name)
              ores << input_amt
            else
              needed[input.name] ||= 0
              needed[input.name]  += input_amt
            end
          end

          in_stock[need.first] ||= 0
          in_stock[need.first]  += output_amt_multiple * k.count - need.last
        end

        needed.each do |k,v|
          puts "\t\t#{k}\t#{v}" if @debug
        end
        puts "#{'#' * 40}" if @debug
      end

      ores.sum
  }

  describe 'part 1' do
    let(:code) {
      GET_ORE.call(input_data)
    }

    describe 'example 0' do
      let(:data) { p1_e0 }

      it 'works' do
        assert_equal(165, code)
      end
    end

    describe 'example 1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal(13312, code)
      end
    end

    describe 'example 2' do
      let(:data) { p1_e2 }

      it 'works' do
        assert_equal(180697, code)
      end
    end

    describe 'example 3' do
      let(:data) { p1_e3 }

      it 'works' do
        assert_equal(2210736, code)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert(232531 > code)
        assert_equal(202617, code)
      end
    end
  end

  describe 'part 2' do
    let(:starting_ores) { 1_000_000_000_000 }
    let(:code) {
      answer = (0..starting_ores).bsearch do |fuel|
        starting_ores < GET_ORE.call(input_data, fuel)
      end

      answer - 1
    }

    describe 'example 1' do
      let(:data) { p1_e1 }

      it 'works' do
        assert_equal(82892753, code)
      end
    end

    describe 'example 2' do
      let(:data) { p1_e2 }

      it 'works' do
        assert_equal(5586022, code)
      end
    end

    describe 'example 3' do
      let(:data) { p1_e3 }

      it 'works' do
        assert_equal(460664, code)
      end
    end

    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        assert_equal(7863863, code)
      end
    end
  end

  let(:p1_e0) {
    <<-STR
    9 ORE => 2 A
    8 ORE => 3 B
    7 ORE => 5 C
    3 A, 4 B => 1 AB
    5 B, 7 C => 1 BC
    4 C, 1 A => 1 CA
    2 AB, 3 BC, 4 CA => 1 FUEL
    STR
  }
  let(:p1_e1) {
    <<-STR
    157 ORE => 5 NZVS
    165 ORE => 6 DCFZ
    44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
    12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
    179 ORE => 7 PSHF
    177 ORE => 5 HKGWZ
    7 DCFZ, 7 PSHF => 2 XJWVT
    165 ORE => 2 GPVTF
    3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
    STR
  }
  let(:p1_e2) {
    <<-STR
    2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
    17 NVRVD, 3 JNWZP => 8 VPVL
    53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
    22 VJHF, 37 MNCFX => 5 FWMGM
    139 ORE => 4 NVRVD
    144 ORE => 7 JNWZP
    5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
    5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
    145 ORE => 6 MNCFX
    1 NVRVD => 8 CXFTF
    1 VJHF, 6 MNCFX => 4 RFSQX
    176 ORE => 6 VJHF
    STR
  }
  let(:p1_e3) {
    <<-STR
    171 ORE => 8 CNZTR
    7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
    114 ORE => 4 BHXH
    14 VRPVC => 6 BMBT
    6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
    6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
    15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
    13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
    5 BMBT => 4 WPTQ
    189 ORE => 9 KTJDG
    1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
    12 VRPVC, 27 CNZTR => 2 XDBXC
    15 KTJDG, 12 BHXH => 5 XCVML
    3 BHXH, 2 VRPVC => 7 MZWV
    121 ORE => 7 VRPVC
    7 XCVML => 6 RJRHP
    5 BHXH, 4 VRPVC => 5 LTCX
    STR
  }
  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) {
    c = {}

    data.lines.map {|line| line.chomp.split('=>')}.each do |parts|
      (output_n, name) = parts.last.strip.split(' ')

      output = OpenStruct.new(name: name, count: output_n.to_i)
      input  = parts.first.split(', ').map {|v| v.split(' ')}.map{|parts| [parts.first.to_i, parts.last]}

      c[output] = input.map {|data| OpenStruct.new(count: data.first, name: data.last) }
    end

    c
  }
end
