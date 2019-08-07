# frozen_string_literal: true

module EpldataHelper
  def fetch_matches
    FootballData.fetch(:competitions, :matches, id: 2021)['matches']
  end

  def last_yr_standings
    s3 = Aws::S3::Client.new
    file = s3.get_object(bucket: ENV['S3_BUCKET'], key: 'lastyr.json')
    JSON.parse(file.body.read)['standings']
  end

  def unlocked_mds
    Matchday.where(locked: false).pluck(:week)
  end

  def unlocked_matchday_times
    mds = unlocked_mds
    return unless mds.any?

    all_matches = fetch_matches
    matchtimes = {}
    mds.each do |m|
      matchtimes[m] = []
      all_matches.each do |t|
        t['matchday'] == m && matchtimes[m].push(t['utcDate'])
      end
    end
    matchtimes
  end

  def update_locktimes
    mds = Matchday.where(locked: false)
    mdtimes = unlocked_matchday_times
    mds.each do |md|
      md.update(lock_time: mdtimes[md.week].min)
    end
  end
end
