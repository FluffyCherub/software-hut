class TmrController < ApplicationController

  def tmr_doc
    @current_feedback_date = FeedbackDate.get_closest_date(Time.now, params['module_id'])
    @tmr_sign_status = TmrSignature.check_signature(current_user.username, @current_feedback_date.id)

    if params['commit'] == "Submit" && @current_feedback_date.tmr_status == "in_progress" && params['file'] != nil && params['file'].content_type == "application/pdf"
      @current_feedback_date.tmr.attach(params['file'])
      @current_feedback_date.update(tmr_status: "submitted")

    else
      #popup
    end

    #accept the tmr
    if params['accept_button'] == "Accept"
      #sign tmr
      TmrSignature.create(signed_by: current_user.username,
                          signed_at: Time.now,
                          feedback_date_id: @current_feedback_date.id)

      if FeedbackDate.check_tmr_completion(params['team_id'], @current_feedback_date.id)
        @current_feedback_date.update(tmr_status: "finished")
      end

      redirect_to tmr_path(team_id: params['team_id'], module_id: params['module_id'])
    elsif params['reject_button'] == "Reject"
      #reject the tmr
      @current_feedback_date.update(tmr_status: "in_progress")
      FeedbackDate.unsign_tmr(@current_feedback_date.id)

      redirect_to tmr_path(team_id: params['team_id'], module_id: params['module_id'])
    end

    #reporting a problem here
    if params['report_button'] == "Report" && params['report_note'] != nil
      Problem.create(created_by: current_user.username,
                     note: params['report_note'],
                     team_id: params['team_id'])

      #popup your problem has been noted or something like that

      redirect_to tmr_path(team_id: params['team_id'], module_id: params['module_id'])
    end
  
  end
end
