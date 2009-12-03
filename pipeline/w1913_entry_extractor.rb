class W1913EntryExtractor
  
  def initialize(start_pattern, end_pattern, eos)
    @eos = eos
  end
  
  def extract(inqueue, outqueue)
    outqueue << @eos
  end
end