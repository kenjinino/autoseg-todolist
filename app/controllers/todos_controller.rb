class TodosController < ApplicationController

  def create
    @todolist = Todolist.find(params[:todolist_id])
    @todo = @todolist.todos.build(params[:todo].except(:todolist_id))
    authorize! :create, @todo

    respond_with(@todolist, @todo) do |format|
      if @todo.save
        flash.now[:notice] = "Todo was successfully created."
        format.js
      else
        format.js { render 'todos/todo_form_reload', todolist: @todolist, todo: @todo }
      end
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    authorize! :destroy, @todo
    @todo.destroy

    respond_with([@todo.todolist, @todo], location:todolist_path(params[:todolist_id]))
  end

  def edit
    @todo = Todo.find(params[:id])
    authorize! :update, @todo
  end

  def update
    @todo = Todo.find(params[:id])
    authorize! :update, @todo
    @todo.update_attributes(params[:todo])

    respond_with @todo, location: todolist_path(@todo.todolist)
  end

  def show
    @todo = Todo.find(params[:id])
    authorize! :read, @todo
    
    respond_with @todo.todolist, @todo
  end

end
