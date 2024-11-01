# Preview all emails at http://localhost:3000/rails/mailers/sys_mailer
class SysMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sys_mailer/waiver_email
  def waiver_email
    SysMailer.waiver_email
  end

end
