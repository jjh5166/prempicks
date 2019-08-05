class GuestPick < ApplicationRecord
  strip_attributes
  belongs_to :user, inverse_of: :guest_picks
  validates :team_id, uniqueness: { scope: %i[half user_id] }, allow_blank: true, on: :update
  validates :user_id, uniqueness: { scope: :matchday }
  attribute :points, :integer, default: 0
  default_scope { order(matchday: :asc) }
end
