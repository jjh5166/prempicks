class PicksController < ApplicationController
  before_action :pick_timer, :authenticate_user!, :team_codes_init, :pick_initialization

  def standings
    @allusers = User.all
  end

  def mypicks
    # If first sign in and no picks exist for user, create a pick for each matchday
    if (current_user.sign_in_count == 1)
      if Pick.where(user_id: current_user.id).count == 0
        (1..38).each do |n|
          h = 2
          if n < 20
            h = 1
          end
          Pick.new(user_id: current_user.id, matchday: n, half: h).save
        end
      end
    end

    @matches = FootballData.fetch(:competitions,:matches, id: 2021)['matches']
    # Call for matches specific team by code
    # @matches = FootballData.fetch(:teams,:matches, id: 73)


    @user_picks = []
    Pick.where(user_id: current_user.id).each do |p|
      @user_picks.push(p.team_id)
    end
    @avail_teams = @pickteams - @user_picks

    @userid = current_user.id

  end

  def make

  @pick = Pick.where(user_id: current_user.id, matchday: params[:matchday])[0]
  @pick = Pick.find_by_id(params[:pick_id])
    if @pick.update(pick_params)
      flash[:alert] = 'Pick Made'
    else
      flash[:alert] = 'Pick Unsuccesful'
    end
  redirect_back fallback_location: mypicks_path
  end
  # private
  #   def pick_timer
  #     matches = FootballData.fetch(:competitions,:matches, id: 2021)['matches']
  #     @matchtimes = {}
  #     (1..38).each do |m|
  #       @matchtimes[m] = []
  #       matches.each do |t|
  #         if t['matchday'] == m
  #           @matchtimes[m].push(t['utcDate'])
  #         end
  #       end
  #     end
  #     @md_count = 0
  #     (1..38).each do |t|
  #       if Time.now.utc > @matchtimes[t].min.in_time_zone('UTC')
  #         @md_count += 1
  #       end
  #     end
  #   end
    # def team_codes_init
    #   path = Rails.root.join "app", "assets", "data", "code_to.json"
    #   file = File.read(path)
    #   @teamcodes = JSON.parse(file)
    # end
    def pick_params
      params.require(:pick).permit(:user_id, :matchday, :team_id)
    end

    def pick_initialization
      path = Rails.root.join "app", "assets", "data", "allTeams.json"
      file = File.read(path)
      @allteams = JSON.parse(file)
      @pickteams = []
      @allteams.each do |t|
      @pickteams.push(t["code"])
      end
    end
end
