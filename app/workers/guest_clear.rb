# frozen_string_literal: true

require 'sidekiq-scheduler'

# clear guest objects from dB
class GuestClear
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform
    g_users = User.where(fname: 'guest', guest: true)
    g_users.destroy_all
  end
end
