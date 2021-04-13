class TmrController < ApplicationController

  def tmr_doc
    @current_team = Team.where(id: params['team_id']).first
    @student_signed_status = UserTeam.check_student_sign_status(current_user.id, params['team_id'])

    if params['commit'] == "Submit" && @current_team.toa_status == "in_progress" && params['file'] != nil && params['file'].content_type == "application/pdf"
      @current_team.document.attach(params['file'])
      @current_team.update(toa_status: "submitted")

    else
      #popup
    end

    if params['accept_button'] == "Accept"
      user_team = UserTeam.where(user_id: current_user.id, team_id: params['team_id'])
      user_team.update(signed_agreement: true)

      if UserTeam.check_toa_completion(params['team_id'])
        @current_team.update(toa_status: "finished")
      end

      redirect_to toa_path(team_id: params['team_id'])
    elsif params['reject_button'] == "Reject"
      @current_team.update(toa_status: "in_progress")
      UserTeam.un_sign_toa(params['team_id'])

      redirect_to toa_path(team_id: params['team_id'])
    end


    if params['report_button'] == "Report" && params['report_note'] != nil
      Problem.create(created_by: current_user.username,
                     note: params['report_note'],
                     team_id: params['team_id'])

      #popup your problem has been noted or something like that

      redirect_to tmr_path(team_id: params['team_id'])
    end
  
  end
end