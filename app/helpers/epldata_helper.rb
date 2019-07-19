# frozen_string_literal: true

module EpldataHelper
  def fetch_matches
    FootballData.fetch(:competitions, :matches, id: 2021)['matches']
  end
  def matches_and_current
    match_data = fetch_matches
    @currentMatchday = match_data[0]['season']['currentMatchday']
    return match_data
  end
  def set_current_matchday
    @currentMatchday = fetch_matches[0]['season']['currentMatchday']
  end
end
