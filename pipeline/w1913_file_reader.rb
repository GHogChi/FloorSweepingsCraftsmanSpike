class W1913FileReader
  
  def initialize(queue, eos)
    @queue = queue
    @eos = eos
  end
  
  def read
    @queue << @eos
  end
  
end