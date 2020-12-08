class Computer
  attr_reader :acc
  attr_reader :ip

  alias :accumulator :acc

  JMP = 'jmp'
  ACC = 'acc'
  NOP = 'nop'

  def initialize
    @acc  = 0
    @ip   = 0
    @code = []
    @seen = []
  end

  def load(code)
    @acc  = 0
    @ip   = 0
    @code = code if code.is_a?(Array)

    self
  end

  def step
    (instruction, value) = @code[@ip].strip.split(' ')

    case instruction
    when JMP
      @ip += value.to_i
    when ACC
      @acc += value.to_i
      @ip  += 1
    when NOP
      @ip += 1
    else
      raise "Invalid instruction #{instruction}"
    end

    self
  end

  def seen?(v = @ip)
    @seen.include?(v)
  end

  def beyond_memory?
    @ip >= @code.size
  end

  def mark_seen(v = @ip)
    @seen << @ip

    self
  end
end
