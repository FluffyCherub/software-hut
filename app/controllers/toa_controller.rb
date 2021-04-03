class ToaController < ApplicationController

  def toa_doc
    #get the current team operating agreement
    @current_toa = TeamOperatingAgreement.find_or_create_by(team_id: params['team_id']) 
    @current_team_size = Team.find(params['team_id']).size
    @team_id = params['team_id']

    

    #redirect_to the locked toa if its already submitted by someone or finished
    if @current_toa.status == "submitted" || @current_toa.status == "finished"
      redirect_to toa_locked_path(team_id: @team_id, team_operating_agreement_id: @current_toa.id)
    end
    
    #update the last_edited field of toa
    @current_toa.update(:last_opened => Time.now)

    #get the signature fields for the current team operating agreement
    @current_toa_signatures = ToaSignature.where("team_operating_agreement_id = ?", @current_toa.id)
    
    #if there is no record of previous signatures create new ones based on team size
    if @current_toa_signatures.length == 0
      @current_toa_signatures = []
      for i in 1..@current_team_size
        @current_toa_signatures.append(ToaSignature.create(:team_operating_agreement_id => @current_toa.id))
      end
    end

    
    if params['save_button'] == "Save"
      toa_to_save = TeamOperatingAgreement.find_by(id: @current_toa.id)
      toa_to_save.update(:project_name => params['update_form']['project_name'],
                         :module_name => params['update_form']['module_name'],
                         :module_leader => params['update_form']['module_leader'],
                         :team_name => params['update_form']['team_name'],
                         :start_date => params['update_form']['start_date'],
                         :end_date => params['update_form']['end_date'],
                         :team_mission => params['update_form']['team_mission'],
                         :team_communications => params['update_form']['team_communications'],
                         :decision_making => params['update_form']['decision_making'],
                         :meetings => params['update_form']['meetings'],
                         :personal_courtesies => params['update_form']['personal_courtesies'],
                         :last_edited => Time.now
                         )
      
      curr_toa_signs = ToaSignature.where(:team_operating_agreement_id => @current_toa.id)
      for i in 1..@current_team_size
        curr_member_name = "member" + i.to_s + "name"
        curr_member_signature = "member" + i.to_s + "signature"
        curr_member_date = "member" + i.to_s + "date"
        curr_toa_signs[i-1].update(:name => params['update_form'][curr_member_name],
                                   :signature => params['update_form'][curr_member_signature],
                                   :date => params['update_form'][curr_member_date])
      
      end

      redirect_to toa_path(:team_id => @team_id)
    elsif params['submit_button'] == "Submit"
      #locking the toa, so it cannot be edited anymore
      @current_toa.update(:status => "submitted")

      #get the current team members
      current_team_members = User.joins(:teams).where("teams.id = ?", @current_toa.id)

      #sending an email to all team members to notify them about the submitted toa
      for i in 0..(current_team_members.length-1)
        UserMailer.toa_submitted_email(current_team_members[i].email, current_team_members[i].givenname, current_user.givenname, current_user.sn).deliver
      end
      

      #redirect_to action: "toa_doc_locked", team_id: @team_id, team_operating_agreement_id: @current_toa.id 
      redirect_to toa_locked_path(team_id: @team_id, team_operating_agreement_id: @current_toa.id)
    end


  end

  def toa_doc_locked
    @current_toa = TeamOperatingAgreement.find_or_create_by(team_id: params['team_id']) 
    @current_team_size = Team.find(params['team_id']).size
    @team_id = params['team_id']

    #checkgin if the curretn toa has been signed by all team members
    @finished_agreement = false
    if @current_toa.status == "finished"
      @finished_agreement = true
    elsif @current_toa.status == "in_progress"
      redirect_to toa_path(:team_id => @team_id)
    end

    #true or false depending on if the current user signed the toa
    @signed_status = UserTeam.where("team_id = ? AND user_id = ?", @team_id, current_user.id).first

    
    #update the last_opened field of toa
    @current_toa.update(:last_opened => Time.now)

    #get the signature fields for the current team operating agreement
    @current_toa_signatures = ToaSignature.where("team_operating_agreement_id = ?", @current_toa.id)
    
    #if there is no record of previous signatures create new ones based on team size
    if @current_toa_signatures.length == 0
      @current_toa_signatures = []
      for i in 1..@current_team_size
        @current_toa_signatures.append(ToaSignature.create(:team_operating_agreement_id => @current_toa.id))
      end
    end

    if params['reject_button'] == "Reject"
      @current_toa.update(:status => "in_progress")
      redirect_to toa_path(:team_id => @team_id)

    elsif params['accept_button'] == "Accept"
      @signed_status.update(:signed_agreement => true)

      #check if every team member accepted the toa
      #get number of team members
      @num_team_members = UserTeam.where("team_id = ?", @team_id)
      @num_signed_toa = UserTeam.where("team_id = ? AND signed_agreement = ?", @team_id, true)
    
      if @num_team_members.length == @num_signed_toa.length
        @current_toa.update(:status => "finished")
      end
      
      redirect_to toa_locked_path(team_id: @team_id, team_operating_agreement_id: @current_toa.id)
    end

  end

end
