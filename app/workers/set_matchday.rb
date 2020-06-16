# frozen_string_literal: true

require 'sidekiq-scheduler'
# sets current matchday
class SetMatchday
  include Sidekiq::Worker
  include EpldataHelper
  def perform
    md = fetch_current_matchday
    cm = CurrentMatchday.find(1)
    update_matchday_if_later(cm, md)
  end
end
