class ResetPasswordMailer < ApplicationMailer
  def reset_password(email, password)
    @password = password
    mail(to: email,
         subject: 'New password for widget api application')
  end
end
