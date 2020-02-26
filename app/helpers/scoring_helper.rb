# frozen_string_literal: true

# Scoring
module ScoringHelper
  # runs python script which saves json file with scores
  def scores_fetch(*matchdays)
    matchdays.each do |m|
      `python3 lib/assets/scoring.py #{m}`
    end
  end

  def locked_not_scored
    Matchday.where(locked: true, scored: false)
  end

  # True if more games finished than scored
  def scoring_needed?
    return false if locked_not_scored.none?

    finished = FootballData.fetch(:competitions, :matches, id: 2021, status: 'FINISHED')['count'].to_i
    scored = Score.where.not(points: 0).count / 2
    return false unless finished > scored

    true
  end

  # return array of integers for matchdays that need to be scored
  def mds_needing_scoring
    Matchday.where(locked: true, scored: false).pluck(:week)
  end

  # updates scores using saved files on s3
  def update_scores(*matchdays)
    s3 = Aws::S3::Client.new
    matchdays.each do |m|
      file = s3.get_object({ bucket: ENV['S3_BUCKET'], key: "scores/matchday#{m}.json" })
      scores = JSON.parse(file.body.read)
      records = scores_to_score(m)
      records.each do |r|
        next unless scores[r.team_id]

        r.update(points: scores[r.team_id])
        Pick.where(matchday: m, team_id: r.team_id).update_all(points: scores[r.team_id])
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
end
