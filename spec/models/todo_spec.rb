require 'spec_helper'

describe Todo do

  let(:user){ FactoryGirl.create(:user) }
  let(:todolist){ FactoryGirl.create(:todolist, user: user ) }

  before do
    @todo = todolist.todos.build(content: "asdf")
  end

  subject{ @todo }

  it { should respond_to :content }
  it { should respond_to :todolist }
  it { should respond_to :done }

  its(:todolist) {should == todolist}

  describe "todolist_id not present" do
    before { @todo.todolist_id = nil }
    it { should_not be_valid }
  end

  describe "blank content" do
    before { @todo.content = " " }
    it { should_not be_valid }
  end

  describe "content is too long" do
    before { @todo.content = "a" * 501 }
    it { should_not be_valid }
  end
end
