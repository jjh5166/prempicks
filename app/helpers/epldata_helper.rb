# frozen_string_literal: true

module EpldataHelper
  def fetch_matches
    FootballData.fetch(:competitions, :matches, id: 2021)['matches']
  end
end
