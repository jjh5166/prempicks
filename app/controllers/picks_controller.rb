# frozen_string_literal: true

# Standings and MyPicks views for users and guests
class PicksController < ApplicationController
  include PicksHelper
  include AutopickHelper
  include EpldataHelper
  before_action :authenticate_user!, :set_my_picks, only: [:mypicks]
  before_action :seed_guest_picks, :set_guest_picks, only: [:guest_mypicks]
  before_action :set_samples, only: [:guest_standings]
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
    @matches =
      matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }
    @teamcodes = team_codes
    @user = current_user
  end

  def guest_mypicks
    @locked_mds = locked_mds
    matches_data = fetch_matches
    @matches =
      matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }
    @teamcodes = team_codes
    @guser = User.find(guest_user.id)
  end

  def guest_standings
    @seasontotals = @all_standings.sort_by { |u| u['season'] }.reverse
    @firsthalftotals = @all_standings.sort_by { |u| u['firsthalf'] }.reverse
    @secondhalftotals = @all_standings.sort_by { |u| u['secondhalf'] }.reverse
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

  def set_samples
    s3 = Aws::S3::Client.new
    standings_file =
      s3.get_object(bucket: ENV['S3_BUCKET'], key: 'sample/sample_standings.json')
    @all_standings = JSON.parse(standings_file.body.read)
    picks_file =
      s3.get_object(bucket: ENV['S3_BUCKET'], key: 'sample/sample_picks.json')
    @sample_picks = JSON.parse(picks_file.body.read)
  end
end
