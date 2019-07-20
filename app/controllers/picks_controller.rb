# frozen_string_literal: true

class PicksController < ApplicationController
  include PicksHelper
  include AutopickHelper
  include EpldataHelper
  before_action :lock_matchdays, only: %i[standings mypicks]
  before_action :authenticate_user!, :seed_picks, :set_my_picks, :pick_initialization, only: [:mypicks]
  # before_action :set_current_matchday, only: :standings

  def standings
    all_standings = load_standings
    @seasontotals = all_standings.order(Arel.sql('SUM(picks.points) DESC'))
    @firsthalftotals = all_standings.order(Arel.sql('firsthalf DESC'))
    @secondhalftotals = all_standings.order(Arel.sql('secondhalf DESC'))
    @unlocked_mds = unlocked_mds
    @current_matchday = 38 # testing
    @first_timer = @current_matchday < 20 ? @current_matchday : 19
    @second_timer = @current_matchday - @first_timer
  end

  def mypicks
    @locked_mds = locked_mds
    matches_data = matches_and_current
    @matches = matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }
    @teamcodes = team_codes
    @user = User.find(current_user.id)
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
    allteams = last_yr_standings
    @pickteams = []
    allteams.each do |t|
      @pickteams.push(t)
    end
  end
end
