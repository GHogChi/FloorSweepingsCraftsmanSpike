require 'pos_extractor'
require 'pos_triple'
require 'lib/fake_char_stream' 
describe PosExtractor do

  before(:each) do
    @ex = PosExtractor.new  
  end


  it "should return an empty array on no match" do
    mockCS = FakeCharacterStream.new('')
    @ex.extract_pos_triples(mockCS).should eql []
  end
  
  it "should return a correct pos_triple" do
    mockCS = FakeCharacterStream.new('<hw>A</hw>fskkjhd<pos><i>a.</i></pos>')
    pts = @ex.extract_pos_triples(mockCS)
    pts.size.should eql 1
  end
end