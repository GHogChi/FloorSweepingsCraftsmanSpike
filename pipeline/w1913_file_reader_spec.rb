

describe 'W1913FileReader' do
  
  it "should put EOS on the queue when there are no files" do
    eos = '***EOS'
    queue = Queue.new
    W1913FileReader.new(queue, eos).read
    queue.pop.should eql eos
  end
  
end