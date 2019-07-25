# frozen_string_literal: true

class CurrentMatchday < ApplicationRecord
  validates_inclusion_of :singleton_guard, in: [0]
end
