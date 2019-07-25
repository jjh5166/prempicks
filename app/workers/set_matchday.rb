require 'sidekiq-scheduler'

class SetMatchday
  include Sidekiq::Worker
  include EpldataHelper
  sidekiq_options retry: false
  def perform
    md = fetch_current_matchday
    CurrentMatchday.find(1).update(matchday:md)
  end
end
