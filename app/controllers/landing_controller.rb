class LandingController < ApplicationController
  before_action :log_out_guest, only: [:landing]
  def landing_page; end
end
