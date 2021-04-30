#---------------------------------------------------------------
# Controller used for saving/displaying the team meeting record
#---------------------------------------------------------------
# Authors: Dominik Laszczyk/Ling Lai
# Date: 12/04/2021
#---------------------------------------------------------------

class TmrController < ApplicationController

  # action for saving/accpeting/rejecting the team meeting record
  def tmr_doc
    @team_id = params['team_id']
    @unfinished_tmr = Tmr.get_unfinished_tmr(@team_id)

    #check if the current user signed tmr in the system
    if @unfinished_tmr != nil
      @unfinished_tmr_sign_status = TmrSignature.check_signature(current_user.username, @unfinished_tmr.id)
    end

    #check if file was submitted and if it has the correct extension(application/pdf)
    if params['commit'] == "Submit"  && params['file'] != nil && params['file'].content_type == "application/pdf"
      Tmr.add_tmr(@team_id, params['file'])
      
      redirect_to tmr_path(team_id: params['team_id'], module_id: params['module_id'])
    else
      #popup wrong file format/file not selected
    end

    #accept the tmr
    if params['accept_button'] == "Accept"
      #sign tmr
      TmrSignature.create(signed_by: current_user.username,
                          signed_at: Time.now,
                          tmr_id: @unfinished_tmr.id)

      #check if tmr is signed by every team member and if yes, change status to finished
      if Tmr.check_tmr_completion(@unfinished_tmr.id, @team_id)
        @unfinished_tmr.update(status: "finished")
      end

      redirect_to tmr_path(team_id: params['team_id'], module_id: params['module_id'])
    elsif params['reject_button'] == "Reject"
      #reject the tmr
      @unfinished_tmr.destroy

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
