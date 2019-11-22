# frozen_string_literal: true

require 'sidekiq-scheduler'
# updates Db for earliest match time of matchday
class MatchdayTimes
  include Sidekiq::Worker
  include EpldataHelper
  def perform
    update_locktimes
  end
end
