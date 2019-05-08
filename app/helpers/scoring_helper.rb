# frozen_string_literal: true

# Scoring
module ScoringHelper
  # runs python script which saves json file with scores
  def scores_fetch(*matchdays)
    matchdays.each do |m|
      `python3 lib/assets/scoring.py #{m}`
    end
  end

  # True if more games finished than scored
  def scoring_needed?
    finished = FootballData.fetch(:competitions, :matches, id: 2021, status: 'FINISHED')['count']
    scored = Score.where.not(points: 0).count / 2
    return false unless finished > scored

    true
  end

  # return array of integers for matchdays that need to be scored
  def mds_needing_scoring
    Matchday.where(locked: true, scored: false).pluck(:week)
  end

  # updates scores using saved files
  def update_scores(*matchdays)
    matchdays.each do |m|
      file = File.read("app/assets/data/scores/matchday#{m}.json")
      scores = JSON.parse(file)
      records = scores_to_score(m)
      records.each do |r|
        r.update(points: scores[r.team_id])
      end
    end
  end

  # updates db for matchdays that have completed their scoring
  def matchday_table_update(matchday)
    return unless Score.where(matchday: matchday).where.not(points: 0).count == 20

    Matchday.where(week: matchday).update(scored: true)
  end

  # returns array of scores needing input
  def scores_to_score(matchday)
    Score.where(matchday: matchday).where(points: 0)
  end

  # creates hash of match scores from file
  def matchday_scores(matchday)
    path = Rails.root.join 'app',
                           'assets', 'data', 'scores',
                           "matchday#{matchday}.json"
    file = File.read(path)
    JSON.parse(file)
  end
end
