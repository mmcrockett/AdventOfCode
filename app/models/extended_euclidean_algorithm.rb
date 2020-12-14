class ExtendedEuclideanAlgorithm
  def self.perform(val_a, val_b)
    i = 0
    r = [val_a, val_b].sort.reverse
    s = [1, 0]
    t = [0, 1]
    q = [nil, nil]

    while false == r.last.zero?
      q << r[-2] / r[-1]
      r << r[-2] - (q[-1] * r[-1])
      s << s[-2] - (q[-1] * s[-1])
      t << t[-2] - (q[-1] * t[-1])
    end

    r.each_with_index do |m, i|
      puts [i, q[i], r[i], s[i], t[i]].join("\t")
    end

    OpenStruct.new(
      gcd: r[-2],
      s: s[-1],
      t: t[-1],
      b0: s[-2],
      b1: t[-2],
    )
  end
end
