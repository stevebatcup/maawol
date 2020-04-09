class ClearanceMailer < MaawolMailer
  def change_password(user)
    vars = {
      RESET_LINK: edit_user_password_url(user, token: user.confirmation_token.html_safe),
      FNAME: user.first_name
    }
    subject = "Reset your password"
    body = mandrill_template('password-reset', merge_vars(vars))
    send_mail(user.email, subject, body, user.first_name, user.id)
  end
end