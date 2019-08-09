# frozen_string_literal: true

# manage guest users
module AuthorizationHelper
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        # logging_in
        # reload guest_user to prevent caching problems before destruction
        guest_user(with_retry = false).try(:reload).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

    # find guest_user object associated with the current session,
    # creating one as needed
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  def guest?
    !!guest_user
  end

  private

  # creates guest user by adding a record to the DB
  # with a guest name and email
  def create_guest_user
    u = User.create(fname: 'guest', email: "guest_#{Time.now.to_i}#{rand(99)}@example.com", guest: true)
    u.save!(validate: false)
    session[:guest_user_id] = u.id
    #  flash[:alert] = "You have logged in as a guest!"
    u
  end
end
