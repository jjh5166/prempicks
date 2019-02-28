# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthorizationHelper

  protect_from_forgery
  before_action { flash.clear }
  # before_action :pick_timer

  FootballData.configure do |config|
    # get api key at 'http://api.football-data.org/register'
    config.api_key = '34cddfbc8f4a4b67acafbdc8b5db300d'

    # default api version is 'alpha' if not setted
    config.api_version = 'v2'

    # the default control method is 'full' if not setted
    # see request section on 'http://api.football-data.org/documentation'
    config.response_control = 'full'
    # config.response_control = 'minified'
  end

  private

  def team_codes
    path = Rails.root.join 'app', 'assets', 'data', 'code_to.json'
    file = File.read(path)
    JSON.parse(file)
  end
end
