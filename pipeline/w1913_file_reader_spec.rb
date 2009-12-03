# I don't get the need for the dir here - how does spec or Ruby know the TextMate project root?
require 'pipeline/w1913_file_reader'
require 'thread'

describe W1913FileReader do
  EOS = '***EOS'
  
  before(:each) do
    @queue = Queue.new
  end
  
  it "should put EOS on the queue when there are no files" do
    reader = W1913FileReader.new(@queue, EOS, 99)
    run_reader(reader, [])
    @queue.pop.should eql EOS
  end

  it "should copy a file shorter than the buffer length into the output queue, terminating with EOS" do
    contents = "Short string"
    infile = StringIO.new(contents, "r")
    reader = W1913FileReader.new(@queue, EOS, 99)
    run_reader(reader,[infile])
    @queue.pop.should eql "#{contents}#{EOS}"
  end
  
  private
  def run_reader(reader, files) 
    popped = nil
    producer = Thread.new do
      reader.read(files)
    end
    producer.join
  end
  
end