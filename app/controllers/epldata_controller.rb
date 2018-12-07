class EpldataController < ApplicationController
  # before_action :pick_timer,
  before_action :team_codes_init

  def table
  @epl_table = FootballData.fetch(:competitions,:standings, id: 2021)['standings'][0]['table']
  end

  def schedule
    @matches = FootballData.fetch(:competitions,:matches, id: 2021)['matches']
  # @matchday = FootballData.fetch(:competitions, :matches, id: 2021, matchday: params[:matchday])
  end


  def matchday
    @md_matches = FootballData.fetch(:competitions,:matches, id: 2021, matchday: params[:matchday])['matches']
  end

  private

end
