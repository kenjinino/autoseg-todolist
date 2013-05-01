require 'spec_helper'

describe Todolist do

  it { should respond_to :bookmarks }
  it { should respond_to :bookmarkers }
  it { should respond_to :bookmarker? }

  it { should respond_to :todos }

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


  describe "todo association" do
    let!(:todo) { FactoryGirl.create(:todo, todolist: todolist) }
    
    context "when destroying todolist" do
      before do
#        todolist.save.should be_true
      end


      it "has to destroy associated todos" do
        todos = todolist.todos.dup
        todolist.destroy
        todos.should_not be_empty

        todos.each { |t| Todo.find_by_id(t.id).should be_nil }
        
      end
    end
  end
end
