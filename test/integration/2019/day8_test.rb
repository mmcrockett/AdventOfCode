require 'test_helper'

class Day8Test < ActiveSupport::TestCase
  let(:p1_e0) { '123456789012' }
  let(:p2_e0) { '0222112222120000' }
  let(:puzzle) { read_test_file(File.join('aoc', 'day8_input.txt')).chomp }
  let(:input_data) { data }

  describe 'part 1' do
    describe 'layers' do
      let(:data) { p1_e0 }
      let(:eid) { ElfImageDecoder.new(data, width: 3, height: 2) }

      it 'works' do
        assert_equal(0, data.chars.size % (3 * 2))
        assert_equal('123456', eid.pixels.first)
        assert_equal('789012', eid.pixels.second)
      end
    end

    describe 'answer' do
      let(:data) { puzzle }
      let(:eid) { ElfImageDecoder.new(data, width: 25, height: 6) }

      it 'works' do
        assert_equal(0, data.chars.size % (25 * 6))
        answer = {}

        eid.pixels.each do |pixel|
          counts = {}

          pixel.chars.each do |char|
            counts[char] ||= 0
            counts[char] +=  1
          end

          answer = counts if answer.empty? || answer['0'] > counts['0']
        end

        assert_not_equal(1331, answer['1'].to_i * answer['2'].to_i)
        assert_equal(2440, answer['1'].to_i * answer['2'].to_i)
      end
    end
  end

  describe 'part 2' do
    describe 'message' do
      let(:data) { p2_e0 }
      let(:eid) { ElfImageDecoder.new(data, width: 2, height: 2) }

      it 'works' do
        puts ''
        2.times do |x|
          2.times do |y|
            print "#{eid.color(x,y)}"
          end
          puts ''
        end
      end
    end

    describe 'final message' do
      let(:data) { puzzle }
      let(:eid) { ElfImageDecoder.new(data, width: width, height: height) }
      let(:width) { 25 }
      let(:height) { 6 }

      it 'works' do
        puts ''
        height.times do |y|
          width.times do |x|
            print "#{eid.color(x,y)}"
          end
          puts ''
        end
      end
    end
  end
end
