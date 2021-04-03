class UserMailer < ApplicationMailer
  default from: 'TeamWorks <no-reply@sheffield.ac.uk>'
  #layout 'mailers'


  

  

  def toa_submitted_email(email, first_name)
    @first_name = first_name

    mail(to: email,
         subject: 'Team Operating Agreement - Submission')
  end
    
end
