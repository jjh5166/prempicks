class EpldataController < ApplicationController
  before_action :pick_timer, :team_codes_init, :authenticate_user!

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
  # def team_initialization
  #   path = Rails.root.join "app", "assets", "data", "code_to.json"
  #   file = File.read(path)
  #   @teamcodes = JSON.parse(file)
  # end
end
