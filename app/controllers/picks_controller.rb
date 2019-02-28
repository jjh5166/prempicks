# frozen_string_literal: true

class PicksController < ApplicationController
  include PicksHelper
  include AutopickHelper
  before_action :lock_matchdays, only: %i[standings mypicks]
  before_action :authenticate_user!, only: %i[mypicks make]
  before_action :seed_picks, :pick_initialization, only: [:mypicks]

  def standings
    all_standings = load_standings
    @seasontotals = all_standings.order(Arel.sql('SUM(picks.points) DESC'))
    @firsthalftotals = all_standings.order(Arel.sql('firsthalf DESC'))
    @secondhalftotals = all_standings.order(Arel.sql('secondhalf DESC'))
    @unlocked_mds = unlocked_mds
    @md_count = matchday_count
    @first_timer = @md_count < 20 ? @md_count : 19
    @second_timer = @md_count - @first_timer
  end

  def mypicks
    @locked_mds = locked_mds
    @matches = FootballData
                .fetch(:competitions, :matches, id: 2021)['matches']
                .sort_by { |match| [match['matchday'], match['utcDate']] }
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
    @md_count = matchday_count
    @userid = current_user.id
    @teamcodes = team_codes
  end

  def make
    @pick = Pick.find_by_id(params[:pick_id])
    flash[:alert] = @pick.update(pick_params) ? 'Pick Saved' : 'Pick Unsuccesful'
    redirect_back fallback_location: mypicks_path
  end

  private

  def load_standings
    points_query = 'users.*, sum(case when half = 1 then points else 0 end)'\
    ' as firsthalf, sum(case when half = 2 then points else 0 end)'\
    ' as secondhalf'
    User.joins(:picks).group('users.id').select(points_query)
  end

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
