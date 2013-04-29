class TodolistsController < ApplicationController
  load_and_authorize_resource

  # GET /todolists
  # GET /todolists.json
  def index
    @todolists = Todolist.where(user_id: current_user.id)

    respond_with @todolists
  end

  # GET /todolists/1
  # GET /todolists/1.json
  def show
    @todolist = Todolist.find(params[:id])

    respond_with @todolist
  end

  # GET /todolists/new
  # GET /todolists/new.json
  def new
    @todolist = Todolist.new

    respond_with @todolist
  end

  # GET /todolists/1/edit
  def edit
    @todolist = Todolist.find(params[:id])
  end

  # POST /todolists
  # POST /todolists.json
  def create
    @todolist = current_user.todolists.new(params[:todolist])
    @todolist.save

    respond_with @todolist
  end

  # PUT /todolists/1
  # PUT /todolists/1.json
  def update
    @todolist = Todolist.find(params[:id])
    @todolist.update_attributes(params[:todolist])

    respond_with @todolist
  end

  # DELETE /todolists/1
  # DELETE /todolists/1.json
  def destroy
    @todolist = Todolist.find(params[:id])
    @todolist.destroy

    respond_with @todolist
  end

  def public
    @todolists = Todolist.where("public = ? AND user_id <> ?", true, current_user.id).includes(:bookmarkers).order("todolists.user_id ASC, todolists.created_at DESC")

    respond_with @todolists
  end

  def bookmarked
    @todolists = current_user.bookmarked_todolists

    respond_with @todolists
  end
end
