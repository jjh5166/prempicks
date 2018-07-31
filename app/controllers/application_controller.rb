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

  $epl_table = FootballData.fetch(:competitions, :matches, id: 2021)
  # :leagueTable, id: 445
end
