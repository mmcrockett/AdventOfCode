# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Year2022::Day08 do
  let(:input) { File.read(File.join(File.dirname(__FILE__), '../../../challenges/2022/08/input.txt')) }
  let(:example_input) do
    <<~EOF
      30373
      25512
      65332
      33549
      35390
    EOF
  end

  describe 'part 1' do
    it 'returns nil for the example input' do
      expect(described_class.part_1(example_input)).to eq(21)
    end

    it 'returns nil for my input' do
      expect(described_class.part_1(input)).to eq(1713)
    end
  end

  describe 'part 2' do
    it 'returns nil for the example input' do
      expect(described_class.part_2(example_input)).to eq(8)
    end

    it 'returns nil for my input' do
      expect(described_class.part_2(input)).to eq(268_464)
    end
  end
end
