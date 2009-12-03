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
  
  it "should break a file longer than the buffer length into separate buffers" do
    s1 = 'string1'
    s2 = 'string2'
    s3 = 'string3'
    infile = StringIO.new("#{s1}#{s2}#{s3}", "r")
    reader = W1913FileReader.new(@queue, EOS, s1.size)
    run_reader(reader,[infile])
    @queue.pop.should eql s1
    @queue.pop.should eql s2
    @queue.pop.should eql s3
    @queue.pop.should eql EOS
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