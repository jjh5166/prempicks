require 'sidekiq-scheduler'

class ScoringJob
  include Sidekiq::Worker
  include ScoringHelper
  sidekiq_options retry: false
  def perform(matchdays)
    matchdays.each do |md|
      md.to_s
      scores_fetch(md)
      update_scores(md)
      matchday_table_update(md)
    end
  end
end
