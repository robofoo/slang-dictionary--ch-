require 'spec_helper'

describe "definitions/show" do
  before(:each) do
    @definition = assign(:definition, stub_model(Definition,
      :word => "Word",
      :definition => "MyText",
      :example => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Word/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
