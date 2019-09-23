# frozen_string_literal: true

require 'sidekiq-scheduler'
# checks for upcoming matches which trigger locking, schedules lock
class LockQueuer
  include Sidekiq::Worker
  include EpldataHelper
  sidekiq_options backtrace: true
  def perform
    mds = Matchday.where(lock_time: Time.current..12.hours.from_now)
    mds.each do |md|
      MatchdayLock.perform_at(md.lock_time, md.week)
    end
  end
end
