# frozen_string_literal: true

require 'sidekiq-scheduler'

class MatchdayLock
  include Sidekiq::Worker
  include PicksHelper
  
  def perform(matchday)
    lock_matchday(matchday)
  end
end
