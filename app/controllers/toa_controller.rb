class ToaController < ApplicationController

  def toa_doc
    puts "BOIIIIIIIIIIIIIIIII"
    puts params['team_id']
    @current_team = Team.where(id: params['team_id']).first

    @student_signed_status = UserTeam.check_student_sign_status(current_user.id, params['team_id'])
    puts "BOIIIIIIIIIIIIIIIII"
    @student_signed_status
    if params['commit'] == "Submit" && @current_team.toa_status == "in_progress"
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
  end

end
