# frozen_string_literal: true

require 'sidekiq-scheduler'
# checks for upcoming matches which trigger locking, schedules lock
class LockQueuer
  include Sidekiq::Worker
  sidekiq_options backtrace: true
  def perform
    mds = Matchday.where(lock_time: Time.current..24.hours.from_now)
    mds.each do |md|
      MatchdayLock.perform_at(md.lock_time, md.week)
    end
  end
end
