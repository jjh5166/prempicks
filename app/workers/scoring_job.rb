# frozen_string_literal: true

require 'sidekiq-scheduler'
# runs scpring script, updates scores, updates matchdays
class ScoringJob
  include Sidekiq::Worker
  include ScoringHelper
  sidekiq_options retry: false, queue: 'scoring'
  def perform(matchdays)
    matchdays.each do |md|
      md.to_s
      scores_fetch(md)
      update_scores(md)
      matchday_table_update(md)
    end
  end
end
