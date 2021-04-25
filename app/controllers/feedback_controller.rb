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
    
    #backup selected values from feedback matrix(set as temp_selected)
    for i in 1..@in_team_without_current_user.length
      attendance = PeerFeedback.feedback_to_int(params['attendance_' + i.to_s])
      attitude = PeerFeedback.feedback_to_int(params['attitude_' + i.to_s])
      qac = PeerFeedback.feedback_to_int(params['qac_' + i.to_s])
      communication = PeerFeedback.feedback_to_int(params['communication_' + i.to_s])
      collaboration = PeerFeedback.feedback_to_int(params['collaboration_' + i.to_s])
      leadership = PeerFeedback.feedback_to_int(params['leadership_' + i.to_s])
      ethics = PeerFeedback.feedback_to_int(params['ethics_' + i.to_s])

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
    end

    # final submission of feedback
    if params['submit_feedback_button'] == "submit_feedback"
      puts "BOIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
    end
  end
end
