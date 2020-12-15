require 'test_helper'

class Day23Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  describe 'part 1' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        queue = {}
        nics  = []

        50.times do |i| 
          queue[i] = [i]
          nics << NicElfComputer.new(input_data, queue, i)
        end

        threads = nics.map {|nic| Thread.new { nic.run } }

        while (queue[255].nil?)
          sleep 0.5
        end

        threads.map(&:kill)

        assert_equal(22650, queue[255].last)
      end
    end
  end

  describe 'part 2' do
    let(:data) { puzzle }

    describe 'solution' do
      it 'works' do
        queue = {}
        nics  = []
        max_t = 300.seconds
        nat   = NotAlwaysTransmitting.new(queue, 255)

        50.times do |i| 
          queue[i] = [i]
          nics << NicElfComputer.new(input_data, queue, i)
        end

        start_t = Time.now
        threads = nics.map {|nic| Thread.new { nic.run } }

        while false == nat.done? && ((start_t + max_t) > Time.now)
          sleep 0.2

          nat.run
        end

        threads.map(&:kill)

        assert((start_t + max_t) > Time.now)
        assert_not_equal(17300, nat.sent_y.last)
        assert_equal(17298, nat.sent_y.last)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(',').map(&:to_i) }
end
