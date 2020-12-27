module Y2020
  class Day19
    # 205 (part 2 too low)
    # 207 (part 2 too low)
    include FileName

    attr_reader :reduced2, :rules

    def initialize(file: nil, file_ext: nil)
      @rules = {}
      @messages = []

      load_data(file_name(file: file, file_ext: file_ext)).each do |line|
        matcher = line.match(/^(?<rule_n>\d+): (?<rule>.+)/)

        if matcher.nil?
          @messages << line unless line.empty?
        else
          @rules[matcher['rule_n']] = matcher['rule'].delete('"')
        end
      end

      #@rules2   = Hash[@rules.map {|k,v| [k, v.split('|').map {|ors| ors.split(' ') }] }]
      #@reduced  = reduce('0', @rules.dup)
      @reduced2 = reduce2('0', @rules)
    end

    def incomplete?(rule)
      rule.flatten.any? {|v| v.match?(/\d/) }
    end

    def reduce2(rule_id, rules)
      rule = rules[rule_id]

      return rule unless rule.match?(/\d/)

      r0 = rule.split('|').map do |subrule|
        r1 = subrule.split(' ').map do |rulepart|
          reduce2(rulepart, rules)
        end

        if r1.flatten.join.include?('|')
          r1 = combine(r1.map {|v| v.split('|') })
        else
          r1 = r1.join
        end

        r1
      end.join('|')

      rules[rule_id] = r0
    end

    def reduce(rule_id, rules)
      rule = rules[rule_id]

      return rule unless rule.match?(/\d/)

      r0 = rule.split('|').map do |subrule|
        subrule.split(' ').map do |rulepart|
          reduce(rulepart, rules)
        end.join('')
      end.join('|')

      rules[rule_id] = "(#{r0})"
    end

    def combine(a)
      t = a.size - 1

      t.times do
        a.unshift(combine_a(a.shift, a.shift))
      end

      a
    end

    def combine_a(p0, p1)
      p0.map do |v0|
        p1.map do |v1|
          "#{v0}#{v1}"
        end
      end.flatten
    end

    def possibilities
      @possibilities ||= @reduced2.split('|')
    end

    def new_valids
      %w[
        bbabbbbaabaabba
        babbbbaabbbbbabbbbbbaabaaabaaa
        aaabbbbbbaaaabaababaabababbabaaabbababababaaa
        bbbbbbbaaaabbbbaaabbabaaa
        bbbababbbbaaaaaaaabbababaaababaabab
        ababaaaaaabaaab
        ababaaaaabbbaba
        baabbaaaabbaaaababbaababb
        abbbbabbbbaaaababbbbbbaaaababb
        aaaaabbaabaaaaababaa
        aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
        aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
      ]
    end

    def possibilities2?(str)
      #result = possibilities.include?(str) || rule8?(str) || rule11?(str)
      result = possibilities.include?(str) || rule8?(str) || rule11?(str)
      #result = possibilities.include?(str) || loop_rule_valid?(str)

      if (result == false && new_valids.include?(str)) || (true == result && new_valids.exclude?(str))
        puts "#{str}:#{rule_replace(str)}:#{new_valids.include?(str)}:#{result}"
        puts "8:  #{str.match?(/^(#{rule42.join('|')})+$/)}"
        puts "11: #{str.match?(/^(#{rule42.join('|')})+(#{rule31.join('|')})+$/)}"
        puts "#{str.size}"
      end

      #puts '-' * 20

      #if (new_valids.include?(str))
        #puts "8:  #{str.match?(/^(#{rule42.join('|')})+$/)}"
        #puts "11: #{str.match?(/^(#{rule42.join('|')})+(#{rule31.join('|')})+$/)}"
      #end
      #debugger if && @debug.nil? && result == false

      result
    end

    def loop_rule_valid?(str)
      'f' != rule_replace(str)
    end

    def rule_replace(str)
      return 'f' unless (str.size % 5).zero?

      sets = str.size / 5
      r    = ''

      sets.times do |t|
        substr = str[t * 5, 5]

        if rule42.any? {|rule| rule.include?(substr) }
          r << '4'
        elsif rule31.any? {|rule| rule.include?(substr) }
          r << '3'
        else
          return 'f'
        end
      end

      return r 
    end

    def rule8?(str)
      return false unless (str.size % 5).zero?

      str.match?(/^(#{rule42.join('|')})+$/)
    end

    def rule11?(str)
      return false unless (str.size % 5).zero?

      n = (str.size / 10)

      str.match?(/^(#{rule42.join('|')}){#{n}}(#{rule31.join('|')}){#{n}}$/)
    end

    def rule42
      @rule42 ||= @rules['42'].split('|')
    end

    def rule31
      @rule31 ||= @rules['31'].split('|')
    end

    def part1
      @messages.select do |m|
        possibilities.include?(m)
      end.size
    end

    def part2
      raise "Never solved - had to lookup solution and actually had two 'finished' solutions give the wrong answer"
      @messages.select do |m|
        possibilities2?(m)
      end.size
    end
  end
end
