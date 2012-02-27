require 'spec_helper'

describe "definitions/edit" do
  before(:each) do
    @definition = assign(:definition, stub_model(Definition,
      :word => "MyString",
      :definition => "MyText",
      :example => "MyText"
    ))
  end

  it "renders the edit definition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => definitions_path(@definition), :method => "post" do
      assert_select "input#definition_word", :name => "definition[word]"
      assert_select "textarea#definition_definition", :name => "definition[definition]"
      assert_select "textarea#definition_example", :name => "definition[example]"
    end
  end
end
