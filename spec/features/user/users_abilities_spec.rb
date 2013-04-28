require 'spec_helper'

describe "Users abilities" do

  subject { page }
  context "when a user is not logged in" do

    let!(:todolist) { FactoryGirl.create(:todolist) }

    it "does not have permission to access todolists_path" do
      visit todolists_path
      current_path.should eq(root_path)
      should have_content("You are not signed in.")
    end

    it "does not have permission to access todolist_path" do
      visit todolist_path(todolist)
      current_path.should eq(root_path)
      should have_content("You are not signed in.")
    end

    it "does not have permission to access edit_todolist_path" do
      visit edit_todolist_path(todolist)
      current_path.should eq(root_path)
      should have_content("You are not signed in.")
    end

    it "does not have permission to access new_todolist_path" do
      visit new_todolist_path
      current_path.should eq(root_path)
      should have_content("You are not signed in.")
    end

    it "does not have permission to access public_todolists_path" do
      visit public_todolists_path
      current_path.should eq(root_path)
      should have_content("You are not signed in.")
    end

    it "does not have permission to delete a todolist" do
      page.driver.submit :delete, todolist_path(todolist), {}
      current_path.should eq(root_path)
      should have_content("You are not signed in.")
    end

  end

  context "when a user is logged in" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:public_todolist) { FactoryGirl.create(:todolist, public: true, user: user) }
    let!(:private_todolist) { FactoryGirl.create(:todolist, public: false, user: user) }

    let!(:other_user) {FactoryGirl.create(:user)}
    let!(:other_public_todolist) { FactoryGirl.create(:todolist, public: true, user: other_user) }
    let!(:other_private_todolist) { FactoryGirl.create(:todolist, public: false, user: other_user) }

    let(:todolist) { FactoryGirl.build(:todolist, user: user) }

    before do
      login_as user
    end

    context "when on todolists_path" do
      before { visit todolists_path }
      


      describe "show todolist" do
        it "does have permission to read a public todolist that he own" do
          find("a[href=\"#{todolist_path(public_todolist)}\"]", text: public_todolist.id).click
          current_path.should eq(todolist_path(public_todolist))
          should have_content(public_todolist.title)
        end
  
        it "does have permission to read a private todolist that he own" do
          find("a[href=\"#{todolist_path(private_todolist)}\"]", text: private_todolist.id).click
          current_path.should eq(todolist_path(private_todolist))
          should have_content(private_todolist.title)
        end
      end

      describe "new todolist" do
        it "can click on a new todolist link" do
          should have_link("New", href: new_todolist_path)
        end

        it "can create a new post" do
          click_on "New"

          current_path.should eq(new_todolist_path)
          fill_in "todolist_title", with: todolist.title
          check "todolist_public"

          click_on "Create Todolist"
          should have_content("Todolist was successfully created")

          visit todolists_path
          should have_content(todolist.title)

        end
      end
  
      describe "edit post" do
        it "can click on a edit public todolist link that he owns" do
          should have_link("Edit", href: edit_todolist_path(public_todolist))
        end

        it "can click on a edit private todolist link that he owns" do
          should have_link("Edit", href: edit_todolist_path(private_todolist))
        end

        it "can edit a public todolist he owns" do
          find("a[href=\"#{edit_todolist_path(public_todolist)}\"]").click

          fill_in "todolist_title", with: todolist.title
          uncheck "todolist_public"

          click_on "Update Todolist"
          should have_content("Todolist was successfully updated")

          visit todolists_path
          within(:xpath, "//tr[td/a[@href=\"#{todolist_path(public_todolist)}\"]]") do
            should have_content(todolist.title)
            should have_content(false)
          end
        end

        it "can edit a private todolist he owns" do
          find("a[href=\"#{edit_todolist_path(private_todolist)}\"]").click

          fill_in "todolist_title", with: todolist.title
          check "todolist_public"

          click_on "Update Todolist"
          should have_content("Todolist was successfully updated")

          visit todolists_path
          within(:xpath, "//tr[td/a[@href=\"#{todolist_path(private_todolist)}\"]]") do
            should have_content(todolist.title)
            should have_content(true)
          end
        end
      end

      describe "destroy todolist" do
        it "can click on a destroy public todolist link that he owns" do
          should have_link("Delete", href: todolist_path(public_todolist))
        end
        
        it "can click on a destroy private todolist link that he owns" do
          should have_link("Delete", href: todolist_path(private_todolist))
        end
        
        it "can destroy a public todolist that he owns" do
          click_link("Delete", href: todolist_path(public_todolist))
          should have_content("Todolist was successfully deleted")
          should_not have_content(public_todolist.title)
        end
        
        it "can destroy a private todolist that he owns" do
          click_link("Delete", href: todolist_path(private_todolist))
          should have_content("Todolist was successfully deleted")
          should_not have_content(private_todolist.title)
        end

      end

      context "when on public_todolists_path" do
        before { visit public_todolists_path }

        it "cannot have access to edit link to a todolist that he does not own" do
          click_link(other_public_todolist.id, href: todolist_path(other_public_todolist))
          should_not have_link("Edit", href: edit_todolist_path(other_public_todolist))
        end

        it "cannot have access to destroy link to a todolist that he does not own" do
          click_link(other_public_todolist.id, href: todolist_path(other_public_todolist))
          should_not have_link("Delete", href: todolist_path(other_public_todolist))
        end

        context "when accessing directly" do

          it "cannot have permission to edit a public todolist that he does not own" do
            visit edit_todolist_path(other_public_todolist)
            should have_content("Access denied")
          end
  
          it "cannot have permission to destroy a public todolist that he does not own" do
            page.driver.submit :delete, todolist_path(other_public_todolist), {}
            should have_content("Access denied")
          end

          it "cannot have permission to edit a private todolist that he does not own" do
            visit edit_todolist_path(other_private_todolist)
            should have_content("Access denied")
          end
  
          it "cannot have permission to destroy a public todolist that he does not own" do
            page.driver.submit :delete, todolist_path(other_private_todolist), {}
            should have_content("Access denied")
          end
        end
      end
    end
  end
end

