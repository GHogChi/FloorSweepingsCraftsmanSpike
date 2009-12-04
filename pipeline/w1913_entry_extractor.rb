require 'constituent_extractor'

class W1913EntryExtractor
  
  def initialize(start_pattern, end_pattern, eos)
    raise ArgumentError if start_pattern == nil or start_pattern.empty? or end_pattern == nil or end_pattern.empty?
    @eos = eos
    @ce = ConstituentExtractor.new(start_pattern, end_pattern, eos)
  end
  
  def extract(inqueue, outqueue)
    input = inqueue.pop
    results = @ce.extract(input, 0)
    puts "inqueue popped<br>"
    outqueue << results[0].contents if results[0] != nil
    outqueue << @eos
  end
end