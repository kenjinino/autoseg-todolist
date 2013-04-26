require 'spec_helper'

describe "Todolists" do
  describe "Public" do
    subject { page }

    context "when logged in" do
      let!(:user) { FactoryGirl.create(:user) }
      let!(:public_todolist) { FactoryGirl.create(:todolist, public: true, user: user) }
      let!(:private_todolist) { FactoryGirl.create(:todolist, public: false, user: user) }

      let!(:other_user) {FactoryGirl.create(:user)}
      let!(:other_public_todolist) { FactoryGirl.create(:todolist, public: true, user: other_user) }
      let!(:other_private_todolist) { FactoryGirl.create(:todolist, public: false, user: other_user) }

      before do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        click_button "Sign in"

        click_on "Public todolists"
      end
  
      it "cannot see any todolists created by himself in public_todolists_path" do
        should_not have_content public_todolist.title
        should_not have_content private_todolist.title
      end
  
      it "can only see public todolists in public_todolists_path" do
        should have_content(other_public_todolist.title)
        should_not have_content(other_private_todolist.title)
      end
    end
  end
end
