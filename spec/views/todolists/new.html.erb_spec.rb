require 'spec_helper'

describe "todolists/new" do
  before(:each) do
    assign(:todolist, stub_model(Todolist,
      :title => "MyString",
      :public => false,
      :user => nil
    ).as_new_record)
  end

  it "renders new todolist form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", todolists_path, "post" do
      assert_select "input#todolist_title[name=?]", "todolist[title]"
      assert_select "input#todolist_public[name=?]", "todolist[public]"
      assert_select "input#todolist_user[name=?]", "todolist[user]"
    end
  end
end
