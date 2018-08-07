class Pick < ApplicationRecord
  # after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new
  belongs_to :user
  validates :team_id, :uniqueness => { :scope => :half }, on: :update
  #restricts user from picking same team twice in same half
  validates :user_id, :uniqueness => { :scope => :matchday}
  #restricts picks so only 38 per user

  attribute :points, :integer, default: 0
  # def set_defaults
  #   self.points  ||= 'some value'
  # end
end
