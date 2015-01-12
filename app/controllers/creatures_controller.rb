class CreaturesController < ApplicationController

  def index
    @creatures = Creature.all
    # @creature = Team.new()
  end

  def new
    @creature = Creature.new()
  end

  def edit
    @creature = Creature.find(params[:id])
  end

  def update
    @creature = Creature.find(params[:id])
    @creature.update(creature_params)
    redirect_to @creature
  end

  def show
    @creature = Creature.find_by_id(params[:id])
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
    @creature = Creature.new(creature_params)

    @creature.save
    redirect_to "/creatures"
  end

  def destroy
    @creature = Creature.find(params[:id])
    @creature.destroy
    redirect_to creatures_path
  end

  private

  def creature_params
    params.require(:creature).permit(:name, :desc)
  end

end