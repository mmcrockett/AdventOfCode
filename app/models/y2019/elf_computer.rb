class ElfComputer
  attr_reader :output

  PARSEOP = ->(str) {
    {
      a: str[-5].to_i,
      b: str[-4].to_i,
      c: str[-3].to_i,
      opcode: str[-2].to_i * 10 + str[-1].to_i
    }
  }

  GAME_OUTPUT = ->(v) {
    return ' ' if 0 == v
    return '|' if 1 == v
    return '=' if 2 == v
    return '_' if 3 == v
    return '*' if 4 == v
  }

  def initialize(inputs, code, loop_mode: false, name: SecureRandom.uuid, no_input_mode: :raise)
    @output = []
    @inputs = [inputs].flatten
    @code   = code.dup
    @max    = @code.size.freeze
    @index  = 0
    @rindex = 0
    @lmode  = (true == loop_mode)
    @no_input_mode = no_input_mode
    @name   = name
  end

  def input
    if @inputs.blank?
      raise "No more inputs" if :raise == @no_input_mode
      raise "No input mode is '#{@no_input_mode}' but there is no input"
    end

    @inputs.shift
  end

  def <<(x)
    @output << x
  end

  def ascii_output(clear: true)
    result = @output.to_ascii

    @output = [] if true == clear

    result
  end

  def halted?
    99 == @code[@index]
  end

  def run(next_input = nil)
    running = true

    if next_input.present?
      if next_input.is_a?(Array)
        next_input.each {|z| @inputs << z}
      else
        @inputs << next_input
      end
    end

    clear_output if true == @lmode

    while (@index < @max && @code[@index] != 99 && true == running)
      opcode_data = PARSEOP.call(@code[@index].to_s)
      opcode = opcode_data[:opcode]
      iplus  = 4
      a1     = addr(1, opcode_data[:c])
      a2     = addr(2, opcode_data[:b])
      a3     = addr(3, opcode_data[:a])
      v1     = @code[a1].to_i
      v2     = @code[a2].to_i

      if (1 == opcode || 2 == opcode)
        val  = v1 + v2 if 1 == opcode
        val  = v1 * v2 if 2 == opcode

        @code[a3] = val
      elsif (3 == opcode || 4 == opcode)
        iplus = 2

        if 3 == opcode
          if @inputs.blank? && :break == @no_input_mode
            running = false
            iplus   = 0
          else
            @code[a1] = input
          end
        else
          self << v1

          running = false if true == @lmode
        end
      elsif (5 == opcode || 6 == opcode)
        if (0 == v1) && (6 == opcode) || (0 != v1) && (5 == opcode)
          iplus = 0
          @index = v2
        else
          iplus  = 3
        end
      elsif (7 == opcode || 8 == opcode)
        if (7 == opcode && v1 < v2) || (8 == opcode && v1 == v2)
          @code[a3] = 1
        else
          @code[a3] = 0
        end
      elsif (9 == opcode)
        iplus  = 2
        @rindex += v1
      else
        raise "Parsing fail '#{opcode}'."
      end

      @index += iplus
    end

    return self
  end

  def addr(i, mode)
    idx    = @index + i

    if 1 == mode
      return idx
    elsif 2 == mode
      return @rindex + @code[idx]
    else
      return @code[idx]
    end
  end
end
