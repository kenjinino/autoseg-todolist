require 'spec_helper'

describe "Todos" do
  subject { page }

  context "when logged in" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:public_todolist) { FactoryGirl.create(:todolist, public: true, user: user) }
    let!(:private_todolist) { FactoryGirl.create(:todolist, public: false, user: user) }

    let!(:other_user) {FactoryGirl.create(:user)}
    let!(:other_public_todolist) { FactoryGirl.create(:todolist, public: true, user: other_user) }
    let!(:other_private_todolist) { FactoryGirl.create(:todolist, public: false, user: other_user) }

    let(:todo) { FactoryGirl.build(:todo) }
    let!(:saved_todo) { FactoryGirl.create(:todo, todolist: public_todolist) }
    let!(:other_saved_todo) { FactoryGirl.create(:todo, todolist: other_public_todolist) }
    let(:another_todo) { FactoryGirl.build(:todo) }

    before do
      login_as user
    end

    context "when on own todolist" do
      before do
        click_on "#{public_todolist.id}"
      end
  
      describe "can create a new todo", js: true do
        before do
          fill_in "todo_content", with: todo.content
          click_on "Create Todo"
        end
  
        it do
          current_path.should eq(todolist_path(public_todolist))
          should have_content(todo.content)
        end
      end
  
      describe "can destroy a todo" do
        before do
          click_link("Delete", href: todolist_todo_path(public_todolist.id, saved_todo.id))
        end
  
        it { should_not have_content(saved_todo.content) }
      end
  
      describe "can edit a todo" do
        before do
          click_link("Edit", href: edit_todolist_todo_path(public_todolist.id, saved_todo.id))
          fill_in "todo_content", with: another_todo.content
          click_on("Update Todo")
        end
  
        it { should have_content(another_todo.content) }
      end
  
      describe "can read a todo" do
        before do
          click_link("#{saved_todo.id}")
        end
  
        it { should have_content(saved_todo.content) }
      end
    end

    context "when on others todolist" do
      before do
        click_on "Public todolists"
        click_on "#{other_public_todolist.id}"
      end

      it "cannot click on create todo" do
        should_not have_button("Create Todo")
      end

      it "cannot click on edit todo" do
        within(:xpath, "//tr[td/a[@href=\"#{todolist_todo_path(other_public_todolist, other_saved_todo)}\"]]") do
          should_not have_button("Edit")
        end
      end

      it "cannot click on destroy todo" do
        within(:xpath, "//tr[td/a[@href=\"#{todolist_todo_path(other_public_todolist, other_saved_todo)}\"]]") do
          should_not have_button("Delete")
        end
      end

      it "can read a todo that he does not own" do
        click_on "#{other_saved_todo.id}"
        current_path.should eq(todolist_todo_path(other_public_todolist, other_saved_todo))
        should have_content(other_saved_todo.content)
      end
    end
  end
end
