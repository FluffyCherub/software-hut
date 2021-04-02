class ToaController < ApplicationController

  helper_method :update_toa
  def toa_doc
    @current_toa = TeamOperatingAgreement.find_or_create_by(team_id: params['team_id']) 
    @current_team_size = Team.find(params['team_id']).size
    @team_id = params['team_id']
    
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

    end

  end

  def update_toa
    puts "WTFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
    redirect_to "/modules"
    if params["update_form"] != nil
      puts "BOIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
      puts params["submit_button"]
      puts "BOIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
      # if params["update_form"]["button_1"] == "Submit"
      #   puts "BUTTON 1 YOOOOOOOOO"
      # end
      # if params["update_form"]["button_2"] == "Save"
      #   puts "BUTTON 2 BROOOOOOOO"
      

      #NEED TO PASS MODULE ID FROM VIEW

      # t.string "project_name"
      # t.string "module_name"
      # t.string "module_leader"
      # t.string "team_name"
      # t.string "start_date"
      # t.string "end_date"
      # t.string "team_mission"
      # t.string "team_communications"
      # t.string "decision_making"
      # t.string "meetings"
      # t.string "personal_courtesies"
      # t.datetime "last_opened"
      # t.datetime "last_edited"
      # t.bigint "team_id"

      
      #params['update_form']['']



    end
  end

end
