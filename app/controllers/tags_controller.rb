class TagsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def show
    @tags = Tag.all
  end

  def create
  end

  def destroy
  end

end