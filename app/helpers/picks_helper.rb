module PicksHelper

  def users_no_pick(matchday)
    User.where(matchday: matchday, team_id:nil)
  end
end
