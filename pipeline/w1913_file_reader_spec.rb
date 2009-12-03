# I don't get the need for the dir here - how does spec or Ruby know the TextMate project root?
require 'pipeline/w1913_file_reader'
require 'thread'

describe W1913FileReader do
  
  it "should put EOS on the queue when there are no files" do
    eos = '***EOS'
    queue = Queue.new
    popped = nil
    reader = W1913FileReader.new(queue, eos)
    producer = Thread.new do
      reader.read
    end
    consumer = Thread.new do
      popped = queue.pop
    end
    popped.should eql eos
  end
  
end