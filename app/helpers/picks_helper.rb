# frozen_string_literal: true

# For Standings, Autopicking, Locking
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

  # Set Variables for the three table states in Standings
  def load_standings
    points_query = 'users.*, sum(case when half = 1 then points else 0 end)'\
    ' as firsthalf, sum(case when half = 2 then points else 0 end)'\
    ' as secondhalf'
    standings_totals = User.joins(:picks).group('users.id').select(points_query)
    @seasontotals = standings_totals.order('SUM(picks.points) DESC')
    @firsthalftotals = standings_totals.order('firsthalf DESC')
    @secondhalftotals = standings_totals.order('secondhalf DESC')
  end

  # Determines users who have not picked for specific matchday
  def users_no_pick(matchday)
    @no_pick_users = []
    Pick.where(matchday: matchday, team_id: nil).each do |pick|
      @no_pick_users.push(pick.user_id)
    end
  end

  # Check if team has been selected in future matchday, set variable to md
  def future_picked?(user, team, matchday)
    half = matchday < 20 ? 1 : 2
    return unless selected_ahead = Pick.where(user_id: user, half: half, team_id: team)[0]

    puts 'unpick ' + selected_ahead.team_id
    puts 'matchday ' + selected_ahead.matchday.to_s
    selected_ahead.update(team_id: nil)
  end

  # if team is picked for future, needs to assign future pick back to nil
  def auto_pick(matchday, users)
    lastyr = lastyr_standings
    # creates array of picked teams for each user
    users.each do |user|
      pickedteams = []
      # Array of teams from begining of half until current matchday
      picked = picked_teams_for_auto(user, matchday)

      picked.each do |pick|
        pickedteams.push(pick.team_id) unless pick.team_id.nil?
      end
      # cycles thru last years standings finding highest placed
      # team yet to be selected
      puts 'USER' + user.to_s
      lastyr.each do |team|
        if pickedteams.include?(team)
          puts 'Picked' + team
        else
          puts 'AUTO PICK ' + team
          future_picked?(user, team, matchday)
          autopick = Pick.where(matchday: matchday, user_id: user)
          autopick.update(team_id: team)
          break
        end
      end
    end
  end

  private

  def lastyr_standings
    path = Rails.root.join 'app', 'assets', 'data', 'lastyr.json'
    file = File.read(path)
    JSON.parse(file)['standings']
  end

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
    all_matches = FootballData.fetch(:competitions, :matches, id: 2021)['matches']
    matchtimes = {}
    (mds.min..mds.max).each do |m|
      matchtimes[m] = []
      all_matches.each do |t|
        t['matchday'] == m && matchtimes[m].push(t['utcDate'])
      end
    end
    matchtimes
  end

  def picked_teams_for_auto(user, matchday)
    s = matchday < 20 ? 1 : 20
    Pick.where(user_id: user, matchday: s..matchday)
  end
end
