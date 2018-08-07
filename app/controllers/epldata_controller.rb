class EpldataController < ApplicationController
  before_action :team_initialization
  # before_action :authenticate_user!
  def table
  @epl_table = FootballData.fetch(:competitions,:standings, id: 2021)['standings'][0]['table']
# MUST MOVE TO one time welcome page
    if (user_signed_in? && current_user.sign_in_count == 1)
      (1..38).each do |n|
        h = 2
        if n < 20
          h = 1
        end
        Pick.new(user_id: current_user.id, matchday: n, half: h).save
      end
    end
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
    @allteams = JSON.parse(file)
    # @pickteams = []
    # @allteams.each do |t|
    #   @pickteams.push(t["code"])
    # end
  end
end
