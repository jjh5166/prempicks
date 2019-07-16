class Pick < ApplicationRecord
  # after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new
  strip_attributes
  belongs_to :user, inverse_of: :picks
  validates :team_id, uniqueness: { scope: %i[half user_id] }, allow_blank: true, on: :update
  # restricts user from picking same team twice in same half
  validates :user_id, uniqueness: { scope: :matchday }
  # restricts picks so only 38 per user

  attribute :points, :integer, default: 0
  default_scope { order(matchday: :asc) }
  # def set_defaults
  #   self.points  ||= 'some value'
  # end
end
