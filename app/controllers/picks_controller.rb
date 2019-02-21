# frozen_string_literal: true

class PicksController < ApplicationController
  include PicksHelper
  before_action :pick_timer, only: %i[standings mypicks]
  before_action :authenticate_user!, only: %i[mypicks make]
  before_action :seed_picks, :team_codes_init, :pick_initialization, only: [:mypicks]
  before_action :load_standings, only: [:standings]

  def standings
    @first_timer = @md_count < 20 ? @md_count : 19
    @second_timer = @md_count - @first_timer

    if users_no_pick(@md_count).any?
      auto_pick(@md_count, @no_pick_users)
    end
  end

  def mypicks
    @locked_mds = locked_mds
    @test_times = unlocked_matchday_times
    @matches = FootballData.fetch(:competitions, :matches, id: 2021)['matches'].sort_by { |match| [match['matchday'], match['utcDate']] }
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
