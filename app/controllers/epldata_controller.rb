class EpldataController < ApplicationController
  before_action :team_initialization
  # before_action :authenticate_user!
  def table
  @epl_table = FootballData.fetch(:competitions,:standings, id: 2021)['standings'][0]['table']
# MUST MOVE TO one time welcome page

  end
  def schedule
    @matches = FootballData.fetch(:competitions,:matches, id: 2021)['matches']
    # ['standings'][0]['table']
  end
  # def schedule
  #   # @full_schedule = FootballData.fetch(:competitions, :fixtures, id: 2021)
  # end
  # def matchday
  #   # @matchday = FootballData.fetch(:competitions, :fixtures, id: 2021, matchday: params[:matchday])
  # end
  private
  def team_initialization
    path = Rails.root.join "app", "assets", "data", "code_to.json"
    file = File.read(path)
    @teamcodes = JSON.parse(file)
    # @pickteams = []
    # @allteams.each do |t|
    #   @pickteams.push(t["code"])
    # end
  end
end
