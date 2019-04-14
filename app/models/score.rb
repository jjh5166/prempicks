class Score < ApplicationRecord
  validates :matchday, uniqueness: { scope: [:team_id] }, on: :create
end
