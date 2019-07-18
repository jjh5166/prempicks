# frozen_string_literal: true

class StaticPagesController < ApplicationController

  def guest_welcome
    create_guest_user unless user_signed_in?
  end

  private

  def log_out_guest
    session[:guest_user_id] = nil
    flash.clear
  end
end
