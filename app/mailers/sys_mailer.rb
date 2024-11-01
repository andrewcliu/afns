class SysMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sys_mailer.waiver_email.subject
  #
  def waiver_email
    user = "andrew@alamedafns.com"
    mail to: user, subject: 'Waiver'
  end

  def trainer_request_email(trainer_form)
    @trainer_form = trainer_form

    # Include any specific parameters you want to send in the email body
    mail(
      to: 'andrew@alamedafns.com', 
      subject: "New Trainer Form Submission #{Date.today.strftime("%m/%d/%Y")}"
    )
  end

  def guest_agreements 
  end


  def waivers 
  end
end
