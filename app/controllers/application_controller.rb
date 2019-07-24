# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthorizationHelper

  protect_from_forgery

  private

  def team_codes
    path = Rails.root.join 'app', 'assets', 'data', 'code_to.json'
    file = File.read(path)
    JSON.parse(file)
  end
end
