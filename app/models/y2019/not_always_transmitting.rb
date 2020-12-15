class NotAlwaysTransmitting
  attr_reader :sent_y

  def initialize(network, addr)
    @network = network
    @addr    = addr
    @packet  = []
    @sent_y  = []
  end

  def run
    raise "Not given an address!" if @addr.nil?

    if @network[@addr].present? && @network[@addr].size >= 2
      @packet = @network[@addr].last(2)
      @network[@addr] = []
    end

    if @network.values.flatten.empty?
      @sent_y << @packet.last

      @network[0] += @packet
      @packet = []
    end
  end

  def done?
    @sent_y.size >= 2 && @sent_y[-2] == @sent_y[-1]
  end
end
