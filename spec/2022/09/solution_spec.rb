# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Year2022::Day09 do
  let(:input) { File.read(File.join(File.dirname(__FILE__), '../../../challenges/2022/09/input.txt')) }
  let(:example_input) do
    <<~EOF
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
    EOF
  end
  let(:example_input2) do
    <<~EOF
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
    EOF
  end

  describe 'part 1' do
    it 'returns nil for the example input' do
      expect(described_class.part_1(example_input)).to eq(13)
    end

    it 'returns nil for my input' do
      expect(described_class.part_1(input) > 4918).to eq(true)
      expect(described_class.part_1(input)).to eq(6081)
    end
  end

  describe 'part 2' do
    it 'returns nil for the example input' do
      expect(described_class.part_2(example_input)).to eq(1)
      expect(described_class.part_2(example_input2)).to eq(36)
    end

    it 'returns nil for my input' do
      expect(described_class.part_2(input)).to eq(2487)
    end
  end
end
