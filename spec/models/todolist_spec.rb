require 'spec_helper'

describe Todolist do
  let(:todolist) { FactoryGirl.build(:todolist) }
  
  it "cannot have a blank title" do
    todolist.title = " "
    todolist.should_not be_valid
  end

  it "title cannot exceed 255 characters" do
    todolist.title = "a" * 257
    todolist.should_not be_valid
  end

  it "has to be associated with a user" do
    todolist.user = nil
    todolist.should_not be_valid
  end
end
