class PicksController < ApplicationController
  include PicksHelper
  before_action :pick_timer, only: [:standings, :mypicks]
  before_action :authenticate_user!, only: [:mypicks, :make]
  before_action :team_codes_init, only: [:mypicks]
  before_action :pick_initialization, only: [:mypicks]
  before_action :get_picks, only: [:standings]

  def standings
    (@md_count < 20) ? @first_timer = @md_count : @first_timer = 19
    @second_timer = @md_count - @first_timer

    if users_no_pick(@md_count).any?
      auto_pick(@md_count, @no_pick_users)
    end
  end
  def mypicks
    # If first sign in and no picks exist for user, create a pick for each matchday
    if (current_user.sign_in_count == 1)
      if Pick.where(user_id: current_user.id).count == 0
        (1..38).each do |n|
          h = 2
          if n < 20
            h = 1
          end
          Pick.new(user_id: current_user.id, matchday: n, half: h).save
        end
      end
    end

    @matches = FootballData.fetch(:competitions,:matches, id: 2021)['matches']
    # Call for matches specific team by code
    # @matches = FootballData.fetch(:teams,:matches, id: 73)

    @user_picks_1h = []
    @user_picks_2h = []
    Pick.where(user_id: current_user.id, half: 1).each do |p|
      @user_picks_1h.push(p.team_id)
    end
    Pick.where(user_id: current_user.id, half: 2).each do |p|
      @user_picks_2h.push(p.team_id)
    end
    @avail_teams_1h = @pickteams - @user_picks_1h
    @avail_teams_2h = @pickteams - @user_picks_2h

    @userid = current_user.id

  end

  def make
    @pick = Pick.find_by_id(params[:pick_id])
      if @pick.update(pick_params)
        flash[:alert] = 'Pick Saved'
      else
        flash[:alert] = 'Pick Unsuccesful'
      end
    redirect_back fallback_location: mypicks_path
  end
  private

  def pick_params
    params.require(:pick).permit(:user_id, :matchday, :team_id)
  end

  def pick_initialization
    path = Rails.root.join 'app', 'assets', 'data', 'allTeams.json'
    file = File.read(path)
    @allteams = JSON.parse(file)
    @pickteams = []
    @allteams.each do |t|
    @pickteams.push(t['code'])
    end
  end
end
