require 'spec_helper'

describe "todolists/index" do
  before(:each) do
    assign(:todolists, [
      stub_model(Todolist,
        :title => "Title",
        :public => false,
        :user => nil
      ),
      stub_model(Todolist,
        :title => "Title",
        :public => false,
        :user => nil
      )
    ])
  end

  it "renders a list of todolists" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
