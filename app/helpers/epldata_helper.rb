# frozen_string_literal: true

module EpldataHelper
  def fetch_matches
    FootballData.fetch(:competitions, :matches, id: 2021)['matches']
  end

  def fetch_current_matchday
    fetch_matches[0]['season']['currentMatchday']
  end

  def last_yr_standings
    s3 = Aws::S3::Client.new
    file = s3.get_object(bucket: ENV['S3_BUCKET'], key: 'lastyr.json')
    JSON.parse(file.body.read)['standings']
  end
end
