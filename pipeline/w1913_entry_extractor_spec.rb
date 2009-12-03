require 'pipeline/w1913_entry_extractor'

describe W1913EntryExtractor do
  EOS = '***EOS'
  
  it "should put EOS on queue when no entries in input" do
    extractor = W1913EntryExtractor.new('','', EOS)
    inqueue = Queue.new
    outqueue = Queue.new
    t = Thread.new do
      extractor.extract(inqueue, outqueue)
    end
    t.join
    outqueue.pop.should eql EOS
  end
  
end