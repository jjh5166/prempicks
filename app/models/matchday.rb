class Matchday < ApplicationRecord
  default_scope { order(week: :asc) }
end
