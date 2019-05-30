require 'sidekiq-scheduler'

class ScoringCheck
  include Sidekiq::Worker
  include ScoringHelper
  sidekiq_options retry: false
  def perform
    return unless scoring_needed?
      matchday = mds_needing_scoring.first
      ScoringJob.perform_async(matchday)
  end
end