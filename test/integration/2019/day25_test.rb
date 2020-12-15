require 'test_helper'
require 'highline/import'

class Day25Test < ActiveSupport::TestCase
  PUZZLE_FILE = "#{self.name.underscore}.txt"

  describe 'part 1' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'probes' do
        rooms = {}
        passcode = nil
        bad_items = [
          'giant electromagnet',
          'photons',
          'infinite loop',
          'molten lava',
          'escape pod'
        ]
        items = [
        ]
        ec    = ElfComputer.new([], input_data, no_input_mode: :break).run
        depth = 0
        next_command = nil
        current_room = nil
        map_print = false
        debug_p   = false
        hc = :cat

        while true
          current_room.visited!(next_command) if next_command.present?
          current_room = Room.new(from_command: next_command, room_data: ec.ascii_output)
          puts "\t" * depth + "#{current_room.name}" if true == map_print

          if rooms.include?(current_room.name)
            current_room = rooms[current_room.name]
          else
            rooms[current_room.name] = current_room
          end

          current_room.items.each do |item|
            if false == (bad_items + items).include?(item)
              ec.run("take #{item}".to_elfcommand).output.to_ascii
              items << item
            end
          end

          if current_room.next?
            next_command = current_room.next
            depth += 1
            puts "--#{next_command}-->" if true == map_print
          else
            next_command = current_room.go_back
            depth -= 1
            puts "<--#{next_command}--" if true == map_print
            break if next_command.nil?
          end

          ec.run(next_command.to_elfcommand)
        end

        %w(south south west north north north).each {|command| ec.run(command.to_elfcommand); puts "#{ec.ascii_output}" if debug_p }
        items.each {|item| ec.run("drop #{item}".to_elfcommand); puts "#{ec.ascii_output}" if debug_p }

        items.dup.each do |item|
          ["take #{item}", "east", "drop #{item}"].each do |c|
            ec.run(c.to_elfcommand)
            result = ec.ascii_output

            if result.include?('Droids on this ship are lighter than the detected value')
              items.delete(item)
            end

            puts "#{result}" if debug_p
          end
        end

        (2..6).each do |n|
          break if passcode.present?
          items.permutation(n) do |items|
            break if passcode.present?
            commands = items.map {|item| ["take #{item}", "drop #{item}"]}.flatten.sort.reverse
            commands.insert(items.size, "east")

            commands.each do |c|
              ec.run(c.to_elfcommand)
              result = ec.ascii_output

              if "east" == c
                if result.include?('Droids on this ship are heavier than the detected value')
                  Rails.logger.info("VVVVVVVVVV #{items}")
                elsif false == result.include?('Security Checkpoint')
                  passcode = result.match(/\d+/)[0]
                  break
                end
              end

              puts "#{result}" if debug_p
            end
          end
        end

        puts "#{valid_permutations}" if debug_p

        while hc.present? && passcode.nil?
          puts "#{ec.ascii_output}" if debug_p
          hc = ask('command: ')
          ec.run(hc.to_elfcommand)
        end

        assert_equal(19, rooms.size)
        assert_equal(134227456, passcode.to_i)
      end
    end
  end

  describe 'part 2' do
    describe 'solution' do
      let(:data) { puzzle }

      it 'works' do
        skip
        assert_equal(1139528802, answer)
      end
    end
  end

  let(:puzzle) { read_test_file(File.join('aoc', PUZZLE_FILE)) }
  let(:input_data) { data.chomp.split(',').map(&:to_i) }
end
