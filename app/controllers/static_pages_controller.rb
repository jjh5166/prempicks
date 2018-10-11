class StaticPagesController < ApplicationController
    before_action :log_out_guest, only: [:home]
    def home

    end

    private

    def log_out_guest
        session[:guest_user_id] = nil
        flash.clear
    end
end
