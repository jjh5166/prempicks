class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url  = 'prempicks.herokuapp.com'
    mail(to: @user.email, subject: 'Welcome to PremPicks!')
  end

  def new_sign_up_email(user)
    @user = user
    mail(to:'theprempicks@gmail.com', subject: "#{@user.fname} #{@user.lname} just signed up")
  end
end
