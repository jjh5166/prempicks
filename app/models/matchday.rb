class Matchday < ApplicationRecord
  default_scope { order(week: :asc) }
  validates :week, uniqueness: true
end
