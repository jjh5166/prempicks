# frozen_string_literal: true

class EpldataController < ApplicationController

  def table
    @epl_table = FootballData.fetch(:competitions, :standings, id: 2021)['standings'][0]['table']
    @teamcodes = team_codes
  end

  def schedule
    @matches = FootballData.fetch(:competitions, :matches, id: 2021)['matches']
  end

  def matchday
    @md_matches = FootballData.fetch(:competitions, :matches, id: 2021, matchday: params[:matchday])['matches']
  end
end
