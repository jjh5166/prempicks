# frozen_string_literal: true

class PicksController < ApplicationController
  include PicksHelper
  include AutopickHelper
  include EpldataHelper
  before_action :lock_matchdays, only: %i[standings mypicks]
  before_action :authenticate_user!, only: %i[mypicks make]
  before_action :seed_picks, :set_my_picks, :pick_initialization, only: [:mypicks]

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
    matches_data = fetch_matches
    @matches = matches_data.sort_by { |match| [match['matchday'], match['utcDate']] }
    @md_count = matchday_count
    @userid = current_user.id
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
    s3 = Aws::S3::Client.new
    file = s3.get_object(bucket: ENV['S3_BUCKET'], key: 'lastyr.json')
    allteams = JSON.parse(file.body.read)['standings']
    @pickteams = []
    allteams.each do |t|
      @pickteams.push(t)
    end
  end
end
