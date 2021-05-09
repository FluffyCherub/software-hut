#---------------------------------------------------------------
# Controller for saving/dispalying the team operating agreement
#---------------------------------------------------------------
# Authors: Dominik Laszczyk/Ling Lai
# Date: 31/03/2021
#---------------------------------------------------------------

class ToaController < ApplicationController

  #action for saving/accepting/rejecting the team operating agreement
  def toa_doc
    @current_team = Team.where(id: params['team_id']).first
    @student_signed_status = UserTeam.check_student_sign_status(current_user.id, params['team_id'])

    if params['commit'] == "Submit" && @current_team.toa_status == "in_progress" && params['file'] != nil && params['file'].content_type == "application/pdf"
      @current_team.document.attach(params['file'])
      @current_team.update(toa_status: "submitted")

    else
      #popup
    end

    #signing the agreement upon the student clicking accept
    if params['accept_button'] == "Accept"
      user_team = UserTeam.where(user_id: current_user.id, team_id: params['team_id'])
      user_team.update(signed_agreement: true)

      #if all team members signed changing the toa status to finished
      if UserTeam.check_toa_completion(params['team_id'])
        @current_team.update(toa_status: "finished")
      end

      redirect_to toa_path(team_id: params['team_id'])
    elsif params['reject_button'] == "Reject"
      #if a student rejected the toa, changing its status back to in_progress
      @current_team.update(toa_status: "in_progress")
      UserTeam.un_sign_toa(params['team_id'])
      @current_team.document.destroy

      redirect_to toa_path(team_id: params['team_id'])
    end
  end

end
