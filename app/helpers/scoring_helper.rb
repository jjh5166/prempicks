# frozen_string_literal: true

# Scoring
module ScoringHelper
  def scores_fetch(matchday)
    # run python and save json file with scores
    `python3 lib/assets/scoring.py #{matchday}`
  end

  def scoring_needed?
    # return boolean
    # compare API call vs scores table
  end

  def mds_needing_scoring
    # return mds that need to be scored
  end

  def update_scores
    # update scores with scores_fetch object
  end
end
