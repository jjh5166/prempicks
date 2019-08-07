# frozen_string_literal: true
# checks for upcoming matches which trigger locking, schedules lock
require 'sidekiq-scheduler'

class LockQueuer
  include Sidekiq::Worker
  include EpldataHelper
  sidekiq_options retry: false
  def perform
    mds = Matchday.where(lock_time:Time.current..12.hours.from_now)
    mds.each do |md|
      MatchdayLock.perform_at(md.lock_time, md.week)
    end
  end
end
