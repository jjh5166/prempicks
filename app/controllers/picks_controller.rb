# frozen_string_literal: true

class PicksController < ApplicationController
  include PicksHelper
  include AutopickHelper
  include EpldataHelper
  before_action :lock_matchdays, only: %i[standings mypicks]
  before_action :authenticate_user!, :seed_picks, :set_my_picks, only: [:mypicks]
  before_action :seed_guest_picks, :set_guest_picks, only: [:guest_mypicks]
  before_action :pick_initialization, only: %i[mypicks guest_mypicks]

  def standings
    all_standings = load_standings
    @seasontotals = all_standings.order(Arel.sql('SUM(picks.points) DESC'))
    @firsthalftotals = all_standings.order(Arel.sql('firsthalf DESC'))
    @secondhalftotals = all_standings.order(Arel.sql('secondhalf DESC'))
    @unlocked_mds = unlocked_mds
    @upicks = Pick.all.group_by(&:user_id)
    @first_timer = @current_matchday < 20 ? @current_matchday : 19
    @second_timer = @current_matchday - @first_timer
  end

  def mypicks
    @locked_mds = locked_mds
    matches_data = fetch_matches
    @matches = matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }
    @teamcodes = team_codes
    @user = User.find(current_user.id)
  end

  def guest_mypicks
    @locked_mds = locked_mds
    matches_data = fetch_matches
    @matches = matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }
    @teamcodes = team_codes
    @guser = User.find(guest_user.id)
  end

  private

  def load_standings
    points_query = 'users.*, sum(case when half = 1 then points else 0 end)'\
    ' as firsthalf, sum(case when half = 2 then points else 0 end)'\
    ' as secondhalf, sum(points) as season'
    User.joins(:picks).group('users.id').select(points_query)
  end

  def pick_initialization
    allteams = last_yr_standings
    @pickteams = []
    allteams.each do |t|
      @pickteams.push(t)
    end
  end
end
