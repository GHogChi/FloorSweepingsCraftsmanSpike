require 'tag_extractor'


describe TagExtractor do

before(:each) do
  mockCS = mock("char stream")
  def mockCS.set(string)
    @data = string
  end

  def mockCS.each
    while ch = @data.slice!(0)
      yield(ch)
    end
  end
  @mockCS = mockCS
  @ex = TagExtractor.new  
end

  it "should return empty array for no match" do
    @mockCS.set ''
    @ex.find_all_tags(@mockCS).should eql []
  end
  
  it "should find a tag" do
    @mockCS.set '<hw>'
	  @ex.find_all_tags(@mockCS).should eql ['hw']
  end
  
  it "should find multiple tags" do
    @mockCS.set '<hw> werfassrd <zz> wjwi93302hf <aa>'
    @ex.find_all_tags(@mockCS).should eql %w{hw zz aa}
  end
  
  it "should capture end tags" do
    @mockCS.set '<hw>A</hw> asasfasdf <hw>B</hw>'
    @ex.find_all_tags(@mockCS).should eql %w{hw /hw hw /hw}
  end
  
  it "should ignore whitespace" do
    hws = <<-EOH
    <hw>A</hw>
    <
    hw>B</hw>
    EOH
    p hws
    @mockCS.set hws
    @ex.find_all_tags(@mockCS).should eql %w{hw /hw hw /hw}
  end
  
  it "should return empty list when no elements found for tag name" do
    @mockCS.set 'not the woids yer lookin for'
    @ex.find_elements_by_tag_name(@mockCS, 'tag').should eql []
  end
  
  it "should find elements by tagname" do
    @mockCS.set '<tag>A</tag> asdasf <tag>B</tag>'
    found_elements = @ex.find_elements_by_tag_name(@mockCS, ['tag'])
    found_elements.size.should eql 2
    found_elements[0].tag.should eql 'tag'
    found_elements[0].contents.should eql 'A'
    found_elements[1].tag.should eql 'tag'
    found_elements[1].contents.should eql 'B'
  end
  
  it "should find elements by multiple tag names" do
    @mockCS.set '<tag1>A</tag1> asdasf <tag2>B</tag2>'
    found_elements =@ex.find_elements_by_tag_name(@mockCS, ['tag1', 'tag2'])
    found_elements.size.should eql 2
    found_elements[0].tag.should eql 'tag1'
    found_elements[0].contents.should eql 'A'
    found_elements[1].tag.should eql 'tag2'
    found_elements[1].contents.should eql 'B'
end    
  
  
  
end