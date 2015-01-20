class TagsController < ApplicationController

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def show
  end

  def create
    @tag = Tag.all
    @tag = Tag.create(tags_params)

    redirect_to tagc_path
  end

  def destroy
    # @tag = Tag.find(params[:id])
    # if(@tag.creatures.length == 0)
    #   @tag.destroy
    #   redirect_to tags_path
    # else
    #   render :index
    # end
  end

  private

  def tags_params
    params.require(:tag).permit(:name)
  end

end