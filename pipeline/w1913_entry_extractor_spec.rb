require 'pipeline/w1913_entry_extractor'

describe W1913EntryExtractor do
  EOS = '***EOS'
  
  before(:each) do
    @inqueue = Queue.new
    @outqueue = Queue.new
  end
  
  it "should put EOS on queue when no entries in input" do
    extractor = W1913EntryExtractor.new('','', EOS)
    run_extractor(extractor)
    @outqueue.pop.should eql EOS
  end
  
  it "should put one matched entry on the queue" do
    entry = "<hw>A</hw>x"
    input = "#{entry}#{EOS}"
    @inqueue << input
    pattern = '\<hw\>.*?\<\/hw\>'
    
    extractor = W1913EntryExtractor.new(pattern, pattern, EOS)
    run_extractor(extractor)
    @outqueue.pop.should eql entry
    @outqueue.pop.should eql EOS
  end

  private
  def run_extractor(extractor)
    t = Thread.new do
      extractor.extract(@inqueue, @outqueue)
    end
    t.join    
  end
end