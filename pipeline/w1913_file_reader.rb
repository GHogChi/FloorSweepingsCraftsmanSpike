class W1913FileReader
  
  def initialize(queue, eos, buffer_size)
    @queue = queue
    @eos = eos
    @buffer_size = buffer_size
  end
  
  def read(files)
    outbuf = ''
    inbuf = ''
    files.each do |f|
      inbuf << f.readline
      while inbuf.size > @buffer_size do
        @queue << inbuf.slice!(0...@buffer_size)
      end      
    end
    inbuf << @eos
    @queue << inbuf.slice!(0...@buffer_size) if inbuf.size > @buffer_size
    @queue << inbuf if inbuf.size > 0
  end
  
end