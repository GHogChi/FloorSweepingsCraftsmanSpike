# I don't get the need for the dir here - how does spec or Ruby know the TextMate project root?
require 'pipeline/w1913_file_reader'
require 'thread'

describe W1913FileReader do
  
  before(:each) do
    @eos = '***EOS'
    @queue = Queue.new
  end
  
  it "should put EOS on the queue when there are no files" do
    reader = W1913FileReader.new(@queue, @eos, 99)
    run_reader(reader, [])
    @queue.pop.should eql @eos
  end

  it "should copy a file shorter than the buffer length into the output queue, terminating with EOS" do
    contents = "Short string"
    infile = StringIO.new(contents, "r")
    reader = W1913FileReader.new(@queue, @eos, 99)
    run_reader(reader,[infile])
    @queue.pop.should eql "#{contents}#{@eos}"
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