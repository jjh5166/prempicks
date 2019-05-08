require 'sidekiq-scheduler'

class ScoringJob
  include Sidekiq::Worker
  include ScoringHelper
  sidekiq_options retry: false
  def perform(matchday)
    scores_fetch(matchday)
    update_scores(matchday)
    matchday_table_update(matchday)
  end
end
