class FeedbackController < ApplicationController
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

        if current_feedback.first.appreciate.nil? || current_feedback.first.appreciate.length < 1
          feedback_completion = false
          break
        end

        if current_feedback.first.request.nil? || current_feedback.first.request.length < 1
          feedback_completion = false
          break
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

  def feedback_review_all
    module_id = params['module_id']
    @teams_in_module = Team.where(list_module_id: module_id)
    @last_finished_period = FeedbackDate.get_last_finished_period(Time.now, module_id)

    if @last_finished_period.nil?
      render "errors/error_500"
    else
      render layout: 'extra_wide'
    end
  end
end
