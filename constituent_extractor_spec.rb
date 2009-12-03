require 'constituent_extractor'

describe 'ConstituentExtractor' do
  
  before(:each) do
    @headword_pattern = '\<hw\>.*?\<\/hw\>'
    @eos_pattern = '\*\*\*EOS'
    @extractor = ConstituentExtractor.new(@headword_pattern, @headword_pattern, @eos_pattern)
  end
  
  it "should return an empty array for no match" do
    # this headword_matcher will always fail
    failing_matcher = Proc.new {|str| nil}
    result = @extractor.extract('', 0)
    result.should eql [] 
  end
  
  it "should return the proper constituent on a match" do
    tipoff = '<hw>someword</hw>'
    rest = 'something'
    results = @extractor.extract("#{tipoff}#{rest}<hw>anotherword</hw>", 0)
    results.size.should eql 1
    found = results[0]
    found.offset.should eql 0
    found.tipoff.should eql tipoff
    found.contents.should eql "#{tipoff}#{rest}"
  end
  
  it "should return two constituents on two matches" do
    results = @extractor.extract('<hw>A</hw>x<hw>B</hw>y<hw>C</hw>', 0)
    results.size.should eql 2
    results[0].contents.should eql '<hw>A</hw>x'
    results[1].contents.should eql '<hw>B</hw>y'
  end
  
  it "should return a constituent when its followed by an EOS marker" do
    results = @extractor.extract('<hw>A</hw>x***EOS', 0)
    results.size.should eql 1
    results[0].contents.should eql '<hw>A</hw>x'
  end

end