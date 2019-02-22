# frozen_string_literal: true

# For Autopicking, Locking
module PicksHelper
  # seed picks for new user at first sign in
  def seed_picks
    if (current_user.sign_in_count == 1) &&
       Pick.where(user_id: current_user.id).count.zero?
      (1..38).each do |n|
        h = n < 20 ? 1 : 2
        Pick.new(user_id: current_user.id, matchday: n, half: h).save
      end
    end
  end

  private

  def unlocked_mds
    Matchday.where(locked: false).pluck(:week)
  end

  def locked_mds
    locked_mds = {}
    Matchday.all.each do |m|
      locked_mds[m.week] = m.locked
    end
    locked_mds
  end

  # fetch kick off times for each matchday
  def unlocked_matchday_times
    mds = unlocked_mds
    all_matches = FootballData
                    .fetch(:competitions, :matches, id: 2021)['matches']
    matchtimes = {}
    (mds.min..mds.max).each do |m|
      matchtimes[m] = []
      all_matches.each do |t|
        t['matchday'] == m && matchtimes[m].push(t['utcDate'])
      end
    end
    matchtimes
  end
end
