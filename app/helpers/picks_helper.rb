module PicksHelper

  def users_no_pick(matchday)
    @no_pick_users = []
    Pick.where(matchday: matchday, team_id: nil).each do |pick|
      @no_pick_users.push(pick.user_id)
    end
  end
  # Check if team has been selected in future matchday, set variable to md
  def future_picked?(user,team,matchday)
    if matchday<20
      half = 1
    else
      half = 2
    end
    if selected_ahead = Pick.where(user_id:user, half:half, team_id:team)[0]
      selected_ahead.update(team_id:nil)
    end
  end

  # def picked_teams(matchday, user)
  #   picked = Pick.where(user_id: user, matchday: 1..matchday)
  #   picked.each do |pick|
  #     pickedteams = []
  #     unless pick.team_id.nil?
  #       pickedteams.push(pick.team_id)
  #     end
  #   end
  #   return pickedteams
  # end

# needs to work for 1st/2nd halves
# if team is picked for future, needs to assign future pick back to nil
  def auto_pick(matchday, users)
    path = Rails.root.join "app", "assets", "data", "lastyr.json"
    file = File.read(path)
    lastyr = JSON.parse(file)["standings"]
      # creates array of teams that user has picked
    users.each do |user|
      pickedteams = []
        # Array of teams from begining of half until current matchday
      if matchday < 20
        picked = Pick.where(user_id: user, matchday: 1..matchday)
      else
        picked = Pick.where(user_id: user, matchday: 20..matchday)
      end

      picked.each do |pick|
        unless pick.team_id.nil?
          pickedteams.push(pick.team_id)
        end
      end
      # cycles thru last years standings finding highest placed team yet to be selected
      puts "USER" + user.to_s
      lastyr.each do |team|
        if pickedteams.include?(team)
          puts "Picked" + team
        else
          puts "AUTO PICK " + team
          future_picked?(user, team, matchday)
          autopick = Pick.where(matchday:matchday, user_id: user)
          autopick.update(team_id: team)
          break
        end
      end


    end
  end
end