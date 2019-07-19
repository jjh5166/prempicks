# frozen_string_literal: true

class StaticPagesController < ApplicationController

  def guest_welcome
    create_guest_user unless user_signed_in?
  end

end
