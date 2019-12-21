# frozen_string_literal: true

# For Autopicking, Locking
module PicksHelper
  include AutopickHelper

  def seed_guest_picks
    return unless GuestPick.where(user_id: guest_user.id).count.zero?

    (1..38).each do |n|
      h = n < 20 ? 1 : 2
      GuestPick.new(user_id: guest_user.id, matchday: n, half: h).save
    end
  end

  def set_my_picks
    @user_picks_1h = []
    @user_picks_2h = []
    @all_picks = Pick.where(user_id: current_user.id)
    @all_picks.first(19).each do |pick|
      @user_picks_1h.push(pick.team_id)
    end
    @all_picks.last(19).each do |pick|
      @user_picks_2h.push(pick.team_id)
    end
  end

  def set_guest_picks
    @user_picks_1h = []
    @user_picks_2h = []
    @all_picks = GuestPick.where(user_id: guest_user.id)
    @all_picks.first(19).each do |pick|
      @user_picks_1h.push(pick.team_id)
    end
    @all_picks.last(19).each do |pick|
      @user_picks_2h.push(pick.team_id)
    end
  end

  def lock_matchdays
    time_now = Time.now.utc
    matchdays = Matchday.where(locked: false)
    return if matchdays.nil?

    matchdays.each do |md|
      next unless time_now > md.lock_time

      lock_matchday(md)
    end
  end

  def lock_matchday(matchday)
    md = Matchday.find_by(week: matchday)
    md.update(locked: true)
    autopick_on_lock(matchday)
  end

  def autopick_on_lock(matchday)
    return if (no_pick_users = users_no_pick(matchday)).empty?

    auto_pick(matchday, no_pick_users)
  end

  private

  # hash for building mypicks view
  def locked_mds
    locked_mds = {}
    Matchday.all.each do |m|
      locked_mds[m.week] = m.locked
    end
    locked_mds
  end
end
