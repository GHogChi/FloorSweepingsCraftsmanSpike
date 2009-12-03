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
    strings = []
    10.times {|i| strings << "string#{i}"}
    infile = StringIO.new("#{strings.join}", "r")
    
    reader = W1913FileReader.new(@queue, EOS, strings[0].size)
    run_reader(reader,[infile])
    
    strings.size.times {|i| @queue.pop.should eql strings[i]}
    @queue.pop.should eql EOS
  end
  
  it "should queue up contents of multiple files in order" do
    strings = []
    10.times {|i| strings << "string#{i}"}
    files = []
    strings.each {|str| files << StringIO.new(str, "r")}
#    10.times {|i| files << StringIO.new("string#{i}","r")}
    
    reader = W1913FileReader.new(@queue, EOS, "string".size + 1)
    run_reader(reader,files)
    10.times {|i| @queue.pop.should eql strings[i]}
    # Why does the following cause a "gets is a private method" error?
#    10.times {|i| @queue.pop.should eql files[i].rewind.gets}
    @queue.pop.should eql EOS
  end
  
  private
  def run_reader(reader, files) 
    producer = Thread.new do
      reader.read(files)
    end
    producer.join
  end
  
end