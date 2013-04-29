class BookmarksController < ApplicationController
  load_and_authorize_resource

  def create
    @todolist = Todolist.find(params[:bookmark][:todolist_id])
    current_user.bookmark!(@todolist)

#    redirect_to public_todolists_path
    respond_with(@todolist) do |format|
      format.html { redirect_to public_todolists_path }
    end
  end

  def destroy
    @todolist = Bookmark.find(params[:id]).todolist
    current_user.unbookmark!(@todolist)

#    redirect_to public_todolists_path
    respond_with(@todolist) do |format|
      format.html { redirect_to public_todolists_path }
    end
  end

  private

  def interpolation_options
    { resource_name: "Bookmark" }
  end
end
