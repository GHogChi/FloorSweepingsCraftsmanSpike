class W1913FileReader
  
  def initialize(queue, eos, buffer_size)
    @queue = queue
    @eos = eos
    @buffer_size = buffer_size
  end
  
  def read(files)
    @queue << @eos
  end
  
end