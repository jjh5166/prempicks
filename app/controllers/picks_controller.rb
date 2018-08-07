class PicksController < ApplicationController
  before_action :pick_initialization

  def standings
    @allusers = User.all
  end

  def mypicks
    @matches = FootballData.fetch(:competitions,:matches, id: 2021)['matches']
    @user_picks = []
    Pick.where(user_id: current_user.id).each do |p|
      @user_picks.push(p.team_id)
    end
    @avail_teams = @pickteams - @user_picks

    @userid = current_user.id
  end

  def make

  @pick = Pick.where(user_id: current_user.id, matchday: params[:matchday])[0]
  @pick = Pick.find_by_id(params[:pick_id])
    if @pick.update(pick_params)
      flash[:message] = 'Pick Made'
    else
      flash[:message] = 'Pick Unsuccesful'
    end
  redirect_back fallback_location: mypicks_path
  end
  private

    def pick_params
      params.require(:pick).permit(:user_id, :matchday, :team_id)
    end

    def pick_initialization
      path = Rails.root.join "app", "assets", "data", "allTeams.json"
      file = File.read(path)
      @allteams = JSON.parse(file)
      @pickteams = []
      @allteams.each do |t|
      @pickteams.push(t["code"])
      end
    end
end
