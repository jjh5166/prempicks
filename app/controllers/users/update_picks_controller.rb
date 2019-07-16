# frozen_string_literal: true

class Users::UpdatePicksController < Devise::RegistrationsController

    def update_picks
      @user = User.find(current_user.id)
      if @user.update_attributes(picks_params)
        redirect_to mypicks_path
      else
        # error
        redirect_to mypicks_path
      end
    end
private
    def picks_params
      params.require(:user).permit(:id, picks_attributes:[:id, :team_id, :user_id])
    end
end
