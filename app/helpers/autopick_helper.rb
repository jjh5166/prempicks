# frozen_string_literal: true

# Autopicking for picks past deadline
module AutopickHelper
  include EpldataHelper
  # Determines users who have not picked for specific matchday
  def users_no_pick(matchday)
    no_pick_users = []
    Pick.where(matchday: matchday, team_id: nil).each do |pick|
      no_pick_users.push(pick.user_id)
    end
    no_pick_users
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
    lastyr = last_yr_standings
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

  def picked_teams_for_auto(user, matchday)
    s = matchday < 20 ? 1 : 20
    Pick.where(user_id: user, matchday: s..matchday)
  end
end