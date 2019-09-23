# frozen_string_literal: true

require 'sidekiq-scheduler'
# gathers users missing picks and sends reminder emails
class ReminderWorker
  include Sidekiq::Worker
  include AutopickHelper
  sidekiq_options queue: 'mailers'
  def perform(matchday)
    user_ids = users_no_pick(matchday)
    return unless user_ids.any?

    users = User.where(id: user_ids)
    users.each do |u|
      UserMailer.reminder_email(u).deliver_now
    end
  end
end
