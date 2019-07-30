# frozen_string_literal: true

require 'active_support/core_ext/integer/inflections'
class EpldataController < ApplicationController
  def table
    @epl_table = FootballData.fetch(:competitions, :standings, id: 2021)['standings'][0]['table']
    @epl_table_prev = FootballData.fetch(:competitions, :standings, id: 2021, season: 2018)['standings'][0]['table']
    @teamcodes = team_codes
  end

  def schedule
    md_matches = FootballData.fetch(:competitions, :matches, id: 2021, matchday: params[:matchday])['matches']
    @matchday = {}
    @matchday.default_proc = proc { [] }
    md_matches.sort_by! {|k| k['utcDate']}
    md_matches.each do |match|
      dtime = DateTime.parse(match['utcDate'])
      @matchday[dtime.strftime("%B #{ dtime.day.ordinalize }")] += [[match['utcDate'], match['status'],\
                                     { 'home': [match['homeTeam']['id'],match['score']['fullTime']['homeTeam']],\
                                      'away': [match['awayTeam']['id'], match['score']['fullTime']['awayTeam']] }]]
    end
    @teams = team_codes
  end

end
