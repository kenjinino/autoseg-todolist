require 'spec_helper'

describe Todolist do

  it { should respond_to :bookmarks }
  it { should respond_to :bookmarkers }
  it { should respond_to :bookmarker? }

  it { should respond_to :todos }


  let(:user) { FactoryGirl.create(:user) }
  let(:another_user) { FactoryGirl.create(:user) }
  let(:saved_todolist) {FactoryGirl.create(:todolist, user: user)}
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

  subject { saved_todolist }
  its(:user) { should == user }

  describe "#bookmarker?" do
    before do
      another_user.bookmark!(saved_todolist)
    end

    it { should be_bookmarker(another_user) }
    it "when unbookmarking" do
      another_user.unbookmark!(saved_todolist)
      should_not be_bookmarker(another_user)
    end
  end

  describe "#bookmarkers" do
    before do
      another_user.bookmark!(saved_todolist)
    end

    its(:bookmarkers) { should include(another_user) }
  end

  describe "todo association" do
    let!(:todo) { FactoryGirl.create(:todo, todolist: todolist) }
    
    context "when destroying todolist" do

      it "has to destroy associated todos" do
        todos = todolist.todos.dup
        todolist.destroy
        todos.should_not be_empty

        todos.each { |t| Todo.find_by_id(t.id).should be_nil }
        
      end
    end
  end
end
