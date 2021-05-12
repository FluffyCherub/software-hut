class UserMailer < ApplicationMailer
  default from: 'TeamWorks <no-reply@sheffield.ac.uk>'
  #layout 'mailers'

  def toa_submitted_email(email, first_name, submitter_first_name, submitter_last_name)
    @first_name = first_name
    @submitter_first_name = submitter_first_name
    @submitter_last_name = submitter_last_name
    mail(to: email,
         subject: 'Team Operating Agreement - Submission')
  end

  def peer_feedback(email, receiver_full_name, submitter_full_name, feedback_date, feedback_descriptions, module_info, appreciate_array, request_array, period_number)
    @email = email
    @receiver_full_name = receiver_full_name
    @submitter_full_name = submitter_full_name
    @feedback_date = feedback_date
    @feedback_descriptions = feedback_descriptions
    @module_info = module_info
    @appreciate_array = appreciate_array
    @request_array = request_array
    @period_number = period_number
    mail(to: email,
         subject: 'Peer Feedback - ' + module_info.name + " - Week " + period_number.to_s)
  end
    
end
