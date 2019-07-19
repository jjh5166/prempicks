# frozen_string_literal: true

class LandingController < ApplicationController
  before_action :log_out_guest, only: [:landing_page]
  def landing_page; end

  private

  def log_out_guest
    session[:guest_user_id] = nil
    flash.clear
  end
end
