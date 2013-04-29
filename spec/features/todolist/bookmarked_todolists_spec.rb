require 'spec_helper'

describe "Todolists" do
  describe "Bookmarked" do
    subject { page }

    context "when logged in" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:public_todolist) { FactoryGirl.create(:todolist, public: true, user: user) }
      let!(:private_todolist) { FactoryGirl.create(:todolist, public: false, user: user) }

      let!(:other_user) {FactoryGirl.create(:user)}
      let!(:other_public_todolist) { FactoryGirl.create(:todolist, public: true, user: other_user) }
      let!(:other_public_bookmarked_todolist) { FactoryGirl.create(:todolist, public: true, user: other_user, bookmarkers: [user]) }
      let!(:other_private_todolist) { FactoryGirl.create(:todolist, public: false, user: other_user) }


      before do
        login_as user
        click_on "Bookmarked todolists"
      end
  
      it "cannot see any todolists not bookmarked by himself in bookmarked_todolists_path" do
        should_not have_content other_public_todolist.title
      end
  
      it "can only see public todolists bookmarked by himself in bookmarked_todolists_path" do
        should have_content(other_public_bookmarked_todolist.title)
        should_not have_content(other_public_todolist.title)
      end
    end
  end
end
