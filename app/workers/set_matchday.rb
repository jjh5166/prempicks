# frozen_string_literal: true

require 'sidekiq-scheduler'
# sets current matchday
class SetMatchday
  include Sidekiq::Worker
  include EpldataHelper
  def perform
    md = fetch_current_matchday
    CurrentMatchday.find(1).update(matchday: md)
  end
end
