class CreaturesController < ApplicationController

  def index
    @creatures = Creature.all
    # @creature = Team.new()
  end

  def new
    @creature = Creature.new
    @tags = Tag.all
  end

  def edit
    @creature = Creature.find_by_id(params[:id])
    @tags = Tag.all
  end

  def update
    @creature = Creature.find_by_id(params[:id])
    @creature.update(creature_params)
    @creature.save

    @creature.tags.clear
    tags = params[:creature][:tag_ids]
    tags.each do |tag_id|
      @creature.tags << Tag.find(tag_id) unless tag_id.blank?
    end

    redirect_to creatures_path
  end

  def show
    @creature = Creature.find_by_id(params[:id])
    @tags = @creature.tags.map do |tag|
      tag.name
    end
    not_found unless @creature

    name = Creature.find(params[:id]).name
    list = flickr.photos.search :text => name, :sort => "relevance", :per_page => 20
    @results = list.map do |photo|
      FlickRaw.url_s(photo)
    end
    @response = RestClient.get 'http://www.reddit.com/search.json', {:params => {:q => name, :limit => 10}}
    @response_object = JSON.parse(@response)
    @reddit_posts = @response_object['data']['children']
  end

  def create
    @creature = Creature.create(creature_params)
    @tags = Tag.all
    if @creature.errors.any?
      render :new
    else
      @creature.tags.clear
      tags = params[:creature][:tag_ids]

      tags.each do |tag_id|
        @creature.tags << Tag.find(tag_id) unless tag_id.blank?
      end

      flash[:success] = "Your creature has been added"
      redirect_to creatures_path
    end
  end

  def destroy
    @creature = Creature.find_by_id(params[:id])
    @creature.destroy
    redirect_to creatures_path
  end

  def tag
    tag = Tag.find_by_name(params[:tag])
    @creatures = tag ? tag.creatures : []
  end

  private

  def creature_params
    params.require(:creature).permit(:name, :desc)
  end

end