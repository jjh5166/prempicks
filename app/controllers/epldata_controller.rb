# frozen_string_literal: true

class EpldataController < ApplicationController
  def table
    @epl_table = FootballData.fetch(:competitions, :standings, id: 2021)['standings'][0]['table']
    @epl_table_prev = FootballData.fetch(:competitions, :standings, id: 2021, season: 2018)['standings'][0]['table']
    @teamcodes = team_codes
  end

  def schedule
    @md_matches = FootballData.fetch(:competitions, :matches, id: 2021, matchday: params[:matchday])['matches']
  end
end
