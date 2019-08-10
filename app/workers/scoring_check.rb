# frozen_string_literal: true

require 'sidekiq-scheduler'

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
