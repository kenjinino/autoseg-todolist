require 'spec_helper'

describe Bookmark do
  let(:user) { FactoryGirl.create(:user) }
  let(:todolist) { FactoryGirl.create(:todolist, user: user) }
  let(:bookmark) { user.bookmarks.build(todolist_id: todolist.id) }

  subject { bookmark }

  it { should be_valid }
  it { should respond_to :user }
  it { should respond_to :todolist }

  its(:todolist) { should == todolist }
  its(:user) { should == user }

  describe "when user id is not present" do
    before { bookmark.user_id = nil }
    it { should_not be_valid }
  end

  describe "when todolist id is not present" do
    before { bookmark.todolist_id = nil }
    it { should_not be_valid }
  end
end
