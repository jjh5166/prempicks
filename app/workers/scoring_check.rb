# frozen_string_literal: true

require 'sidekiq-scheduler'
# monitors API for finished matches
class ScoringCheck
  include Sidekiq::Worker
  include ScoringHelper
  sidekiq_options retry: false
  def perform
    return unless scoring_needed?

    matchdays = mds_needing_scoring
    ScoringJob.perform_async(matchdays)
  end
end
