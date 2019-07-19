class GuestClear
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(*args)
    g_users = User.where(fname: "guest",lname:"",team_name:"")
    g_users.destroy_all
  end
end
