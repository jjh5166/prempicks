# frozen_string_literal: true

class Matchday < ApplicationRecord
  default_scope { order(week: :asc) }
  validates :week, uniqueness: true
  self.ignored_columns = %w[current]
end
