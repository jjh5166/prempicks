# frozen_string_literal: true
# updates dB for earliest match time of matchday
require 'sidekiq-scheduler'

class MatchdayTimes
  include Sidekiq::Worker
  include EpldataHelper
  sidekiq_options retry: false
  def perform
    update_locktimes
  end
end
