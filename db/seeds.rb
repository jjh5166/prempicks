# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
include AutopickHelper
include EpldataHelper
if !Matchday.any?
  (1..38).each do |week|
    Matchday.create(week:week)
  end
  update_locktimes
end
if !Score.any?
  teams = last_yr_standings
  teams.each do |t|
    (1..38).each do |week|
      Score.create(team_id:t, matchday:week)
    end
  end
end
if !CurrentMatchday.any?
  CurrentMatchday.first_or_create!(singleton_guard: 0, matchday: 1)
end
