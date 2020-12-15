class NicElfComputer
  attr_reader :output

  PARSEOP = ->(str) {
    {
      a: str[-5].to_i,
      b: str[-4].to_i,
      c: str[-3].to_i,
      opcode: str[-2].to_i * 10 + str[-1].to_i
    }
  }

  def initialize(code, network, addr)
    @network = network
    @code    = code.dup
    @max     = @code.size.freeze
    @addr    = addr
    @index   = 0
    @rindex  = 0
    @packet  = []
    @empty_count = 0
  end

  def input
    raise "Not given an address!" if @addr.nil?

    v = @network[@addr].shift

    if v.nil?
      v = -1
      @empty_count += 1
      sleep(0.05) if 0 == (@empty_count % 1_000)
    else
      @empty_count  = 0
    end

    v
  end

  def <<(x)
    raise "Not given an address!" if @addr.nil?

    @packet << x

    if 3 == @packet.size
      addr = @packet.shift

      @network[addr] ||= []
      @network[addr]  += @packet
      @packet = []
    end
  end

  def halted?
    99 == @code[@index]
  end

  def run
    running = true

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
          @code[a1] = input
        else
          self << v1
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
