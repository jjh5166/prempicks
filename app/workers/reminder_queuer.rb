# frozen_string_literal: true

require 'sidekiq-scheduler'
# Checks for upcoming lock times, schedules reminder email job
class ReminderQueuer
  include Sidekiq::Worker
  sidekiq_options backtrace: true
  def perform
    mds = Matchday.where(lock_time: 24.hours.from_now..48.hours.from_now)
    mds.each do |md|
      ReminderWorker.perform_at(md.lock_time - 1.day, md.week)
    end
  end
end
