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
      new_problem = Problem.create(created_by: current_user.username,
                                    note: params['report_note'],
                                    team_id: params['team_id'])

      mod_leads = ListModule.get_mod_leads(params['module_id'])

      for i in 0...mod_leads.length
        email = mod_leads[i].email
        receiver_full_name = mod_leads[i].givenname + " " + mod_leads[i].sn
        created_by = current_user
        module_info = ListModule.find(params['module_id'].to_i)
        team_info = Team.find(@team_id.to_i)
        current_time = Time.now
        problem_note = new_problem.note

        #send email to module leader about the new problem
        UserMailer.new_problem(email, receiver_full_name, created_by, module_info, team_info, current_time, problem_note).deliver
      end


      redirect_to tmr_path(team_id: params['team_id'], module_id: params['module_id'])
    end
  
  end
end
