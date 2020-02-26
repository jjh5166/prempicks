# frozen_string_literal: true

include AutopickHelper
include EpldataHelper
if Matchday.none?
  (1..38).each do |week|
    Matchday.create(week: week)
  end
  update_all_locktimes
end
if Score.none?
  teams = last_yr_standings
  teams.each do |t|
    (1..38).each do |week|
      Score.create(team_id: t, matchday: week)
    end
  end
end
if CurrentMatchday.none?
  CurrentMatchday.first_or_create!(singleton_guard: 0, matchday: 1)
end
