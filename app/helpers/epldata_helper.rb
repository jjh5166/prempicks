# frozen_string_literal: true

# epl data fetching
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

  # returns hash of arrays with kick off times for given matchdays
  def matchdays_times_for(matchdays)
    all_matches = fetch_matches_scheduled
    matchtimes = Hash[matchdays.collect { |md| [md, []] }]
    all_matches.each do |m|
      next unless matchdays.include?(m['matchday'])

      matchtimes[m['matchday']].push(m['utcDate'])
    end
    matchtimes
  end

  # returns hash of arrays with kick off times for all matchdays
  def all_matchday_times
    all_matches = fetch_matches
    matchtimes = Hash[(1..38).collect { |md| [md, []] }]
    all_matches.each do |m|
      matchtimes[m['matchday']].push(m['utcDate'])
    end
    matchtimes
  end

  # update locktimes for all unlocked Matchdays
  def update_locktimes
    matchdays = Matchday.where(locked: false)
    digits = matchdays.pluck(:week)
    mdtimes = matchdays_times_for(digits)
    matchdays.each do |md|
      md.update(lock_time: mdtimes[md.week].min)
    end
  end

  # update all locktimes regardless of past date or locked
  def update_all_locktimes
    matchdays = Matchday.all
    mdtimes = all_matchday_times
    matchdays.each do |md|
      md.update(lock_time: mdtimes[md.week].min)
    end
  end

  # update matchday if api returns a later current matchday than saved in db
  def update_matchday_if_later(current_matchday, md_from_api)
    current_matchday.update(matchday: md_from_api) if md_from_api > current_matchday.matchday
  end
end
