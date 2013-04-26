require 'spec_helper'

describe "todolists/edit" do
  before(:each) do
    @todolist = assign(:todolist, stub_model(Todolist,
      :title => "MyString",
      :public => false,
      :user => nil
    ))
  end

  it "renders the edit todolist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", todolist_path(@todolist), "post" do
      assert_select "input#todolist_title[name=?]", "todolist[title]"
      assert_select "input#todolist_public[name=?]", "todolist[public]"
      assert_select "input#todolist_user[name=?]", "todolist[user]"
    end
  end
end
