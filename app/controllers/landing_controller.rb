# frozen_string_literal: true

# Landing Page
class LandingController < ApplicationController
  before_action :log_out_guest, only: [:landing_page]
  def landing_page
    @sign_up_deadline = Matchday.where(week: 1)[0].lock_time
  end

  private

  def log_out_guest
    session[:guest_user_id] = nil
    flash.clear
  end
end
