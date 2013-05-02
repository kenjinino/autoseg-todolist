require 'spec_helper'
require 'ruby-debug'

describe User do
  it {should respond_to :todolists}
  it {should respond_to :bookmarks}

  it {should respond_to :bookmarked_todolists}
  it {should respond_to :bookmarked?}
  it {should respond_to :bookmark!}
  it {should respond_to :unbookmark!}

  describe "todolist associations" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:todolist) { FactoryGirl.create(:todolist, user: user ) }

    subject {user}
    its(:todolists) { should include(todolist) }

    it "should destroy associated todolists" do
      todolists = user.todolists.dup
      user.destroy
      todolists.should_not be_empty
      todolists.each do |t|
        Todolist.find_by_id(t.id).should be_nil
      end
    end

  end

  describe "bookmarking a todolist" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:todolist) { FactoryGirl.create(:todolist) }

    subject { user }

    before do
      user.bookmark!(todolist)
    end

    it { should be_bookmarked(todolist)}
    its (:bookmarked_todolists) { should include(todolist) }
  

    it { todolist.should be_bookmarker(user) }
    it { todolist.bookmarkers.should include(user) }


    describe "and unbookmarking" do
      before do
        user.unbookmark!(todolist)
      end
  
      it { should_not be_bookmarked(todolist)}
      its (:bookmarked_todolists) {should_not include(todolist) }


      it { todolist.should_not be_bookmarker(user) }
      it { todolist.bookmarkers.should_not include(user) }
    end
  end
end
