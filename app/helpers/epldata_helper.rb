# frozen_string_literal: true

module EpldataHelper
  def fetch_matches
    FootballData.fetch(:competitions, :matches, id: 2021)['matches']
  end

  def fetch_matches_scheduled
    FootballData.fetch(:competitions, :matches, id: 2021, status: 'SCHEDULED')['matches']
  end

  def fetch_current_matchday
    fetch_matches[0]['season']['currentMatchday']
  end

  def last_yr_standings
    s3 = Aws::S3::Client.new
    file = s3.get_object(bucket: ENV['S3_BUCKET'], key: 'lastyr.json')
    JSON.parse(file.body.read)['standings']
  end

  def unlocked_mds
    Matchday.where(locked: false).pluck(:week)
  end

  def matchdays_times_for(matchdays)
    all_matches = fetch_matches_scheduled
    matchtimes = Hash[matchdays.collect { |md| [md, []] }]
    all_matches.each do |m|
      next unless matchdays.include?(m['matchday'])

      matchtimes[m['matchday']].push(m['utcDate'])
    end
    matchtimes
  end

  def update_locktimes
    matchdays = Matchday.where(locked: false)
    digits = matchdays.pluck(:week)
    mdtimes = matchdays_times_for(digits)
    matchdays.each do |md|
      md.update(lock_time: mdtimes[md.week].min)
    end
  end
end
