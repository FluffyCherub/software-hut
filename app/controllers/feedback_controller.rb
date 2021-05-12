#-----------------------------------------------------------------------
# Controller related to views for giving/receiving feedback by students
#-----------------------------------------------------------------------
# Authors: Dominik Laszczyk/ Ling Lai
# Date: 23/04/2021
#-----------------------------------------------------------------------

class FeedbackController < ApplicationController

  #called to change the current ability(used for cancancan)
  def current_ability(module_privilege = "student")
    @current_ability ||= Ability.new(current_user, module_privilege)
  end

  #action used for saving/dispalying data to the feedback matrix
  def feedback_matrix
    #getting ids of module and team
    @module_id = params['module_id']
    @team_id = params['team_id']
    @feedback_date_id = params['feedback_date_id']

    #get students that the current user has to give feedback on
    @in_team_without_current_user = User.joins(:teams)
                                        .where("teams.id = ? AND 
                                                users.id NOT IN (?)",
                                                @team_id,
                                                current_user.id
                                                )
    
    #check if feedback is completed and submitted 
    @is_feedback_completed = PeerFeedback.check_feedback_completion(@in_team_without_current_user, current_user.username, @feedback_date_id)

    if @is_feedback_completed
      render "errors/error_403"
      return
    end

    @feedback_dates = FeedbackDate.get_closest_date(Time.now, @module_id)

    @module_info = ListModule.find(@module_id)

    #backup selected values from feedback matrix(set as temp_selected)
    for i in 1..@in_team_without_current_user.length
      attendance = PeerFeedback.feedback_to_int(params['attendance_' + i.to_s])
      attitude = PeerFeedback.feedback_to_int(params['attitude_' + i.to_s])
      qac = PeerFeedback.feedback_to_int(params['qac_' + i.to_s])
      communication = PeerFeedback.feedback_to_int(params['communication_' + i.to_s])
      collaboration = PeerFeedback.feedback_to_int(params['collaboration_' + i.to_s])
      leadership = PeerFeedback.feedback_to_int(params['leadership_' + i.to_s])
      ethics = PeerFeedback.feedback_to_int(params['ethics_' + i.to_s])
      appreciate = params['appreciate_note_' + i.to_s]
      request = params['request_note_' + i.to_s]

      current_feedback = PeerFeedback.find_or_create_by(created_by: current_user.username,
                                                        created_for: @in_team_without_current_user[i-1].username,
                                                        feedback_date_id: @feedback_date_id)

      if attendance    != nil then current_feedback.update(attendance: attendance) end
      if attitude      != nil then current_feedback.update(attitude: attitude) end
      if qac           != nil then current_feedback.update(qac: qac) end
      if communication != nil then current_feedback.update(communication: communication) end
      if collaboration != nil then current_feedback.update(collaboration: collaboration) end
      if leadership    != nil then current_feedback.update(leadership: leadership) end
      if ethics        != nil then current_feedback.update(ethics: ethics) end
      if appreciate    != nil then current_feedback.update(appreciate: appreciate) end
      if request       != nil then current_feedback.update(request: request) end
      if appreciate    != nil then current_feedback.update(appreciate_edited: appreciate) end
      if request       != nil then current_feedback.update(request_edited: request) end
    end

    # final submission of feedback
    if params['submit_feedback_button'] == "submit_feedback"
      feedback_completion = true

      @in_team_without_current_user.each do |student|
        current_feedback = PeerFeedback.get_feedback_for_user(current_user.username, student.username, @feedback_date_id)
        current_feedback_array = current_feedback.pluck(:attendance, :attitude, :qac, :communication, :collaboration, :leadership, :ethics)[0]
        if current_feedback_array.all? {|i| i.is_a?(Integer) } == false
          feedback_completion = false
          break
        end

        #checking if appreciate/request fields are not empty for level 5 modules
        if @module_info.level == 5
          if current_feedback.first.appreciate.nil? || current_feedback.first.appreciate.length < 1
            feedback_completion = false
            break
          end

          if current_feedback.first.request.nil? || current_feedback.first.request.length < 1
            feedback_completion = false
            break
          end
        end


      end

      if feedback_completion
        @in_team_without_current_user.each do |student|
          feedback_finished = PeerFeedback.get_feedback_for_user(current_user.username, student.username, @feedback_date_id)
          feedback_finished.update(status: "finished")
        end
      else
        #popup some fields for feedback missing
      end

    end
  end

  #action used for reviewing feedback(for module leader or ta with permission to do so)
  def feedback_review_all
    @module_id = params['module_id']
    
    #latest finished feedback period for this module
    @last_finished_period = FeedbackDate.get_last_finished_period(Time.now, @module_id)

    #teams in this module, that are connected to the latest finished feedback period
    @teams_in_module = Team.joins(:feedback_dates)
                           .where("teams.list_module_id = ? AND 
                                   feedback_dates.id = ?", 
                                   @module_id,
                                   @last_finished_period.id)
    
    #rendering errors when no previous feedback period
    #(shouldnt happen, because in this case access to this page is disabled)
    if @last_finished_period.nil? 
      render "errors/error_500"
    elsif @last_finished_period.feedback_status == "approved"
      render "errors/error_500"
    else
      render layout: 'extra_wide'
    end
  end

  #saving feedback onchange(for module leader or ta with permission to do so)
  def save_feedback
    appreciate = params['appreciate']
    request = params['request']
    peer_feedback_id = params['peer_feedback_id']

    if appreciate != nil
      PeerFeedback.find(peer_feedback_id.to_i).update(appreciate_edited: appreciate)
    elsif request != nil
      PeerFeedback.find(peer_feedback_id.to_i).update(request_edited: request)
    end

  end

  #approving feedback for the whole feedback period(for module leader or ta with permission to do so)
  def approve_feedback
    module_id = params['module_id']
    feedback_date_id = params['feedback_date_id']

    #changing stauts to approved when approve button clicked
    if params['approve'] != nil
      FeedbackDate.find(feedback_date_id.to_i).update(feedback_status: "approved")
    end

    #redirecting back to the module page
    respond_to do |format|
      format.js { render js: "window.location = '/admin/modules/preview?module_id=#{module_id}'" }
    end
    
  end

  #action for editing the mailmerge message(only module leader and admin)
  def feedback_mailmerge_edit
    module_id = params['module_id']

    #checking if the current user has access to this page
    current_ability(User.get_module_privilege(module_id, current_user.id))
    authorize! :manage, :feedback_mailmerge_edit

    @module_info = ListModule.find(module_id.to_i)

    #if save button clicked, saving and dispaying alert
    if params['save_message'] == "save" 
      @module_info.update(mailmerge_message: params['message'])

      respond_to do |format|
        format.js { render :js => "myAlertTopSuccess();" }
      end
    end
  end
end
