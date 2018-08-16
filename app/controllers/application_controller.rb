class ApplicationController < ActionController::Base

  FootballData.configure do |config|
    # get api key at 'http://api.football-data.org/register'
    config.api_key = '***REMOVED***'

    # default api version is 'alpha' if not setted
    config.api_version = 'v2'

    # the default control method is 'full' if not setted
    # see request section on 'http://api.football-data.org/documentation'
    config.response_control = 'full'
    # config.response_control = 'minified'
  end
  #create a pick for each matchday on first log in

  private
    def pick_timer
      all_matches = FootballData.fetch(:competitions,:matches, id: 2021)['matches']
      @matchtimes = {}
      (1..38).each do |m|
        @matchtimes[m] = []
        all_matches.each do |t|
          if t['matchday'] == m
            @matchtimes[m].push(t['utcDate'])
          end
        end
      end
      @md_count = 0
      (1..38).each do |t|
        if Time.now.utc > @matchtimes[t].min.in_time_zone('UTC')
          @md_count += 1
        end
      end
    end
end
