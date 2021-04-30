# == Schema Information
#
# Table name: peer_feedbacks
#
#  id                :bigint           not null, primary key
#  appreciate        :string           default("")
#  appreciate_edited :string           default("")
#  attendance        :integer
#  attitude          :integer
#  collaboration     :integer
#  communication     :integer
#  created_by        :string
#  created_for       :string
#  ethics            :integer
#  leadership        :integer
#  qac               :integer
#  request           :string           default("")
#  request_edited    :string           default("")
#  status            :string           default("in_progress")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  feedback_date_id  :bigint
#
# Indexes
#
#  index_peer_feedbacks_on_feedback_date_id  (feedback_date_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_date_id => feedback_dates.id)
#
class PeerFeedback < ApplicationRecord
  belongs_to :feedback_date

  #convert text feedback to integer
  #takes feedback text as string, returns integer
  def self.feedback_to_int(feedback_text = nil)

    if feedback_text == "unsatisfactory"
      return 1
    elsif feedback_text == "needs_improvement"
      return 2
    elsif feedback_text == "meets_expectations"
      return 3
    elsif feedback_text == "exceeds_expectations"
      return 4
    else
      return nil
    end
  end

  #get feedback in array format with integers inside
  #takes created_by as string(username), created_for as string(username), and id of a feedback date object
  #returns array of integers(feedback)
  def self.get_feedback_array_for_user(created_by, created_for, feedback_date_id)
    feedback = PeerFeedback.where(created_by: created_by,
                                  created_for: created_for,
                                  feedback_date_id: feedback_date_id)

    if feedback.length == 0
      return nil
    else
      return feedback.pluck(:attendance, :attitude, :qac, :communication, :collaboration, :leadership, :ethics)[0]
    end

  end

  #get feedback object for student
  #takes created_by as string(username), created_for as string(username), and id of a feedback date object
  #returns PeerFeedback object
  def self.get_feedback_for_user(created_by, created_for, feedback_date_id)
    feedback = PeerFeedback.where(created_by: created_by,
                                  created_for: created_for,
                                  feedback_date_id: feedback_date_id)

    if feedback.length == 0
      return nil
    else
      return feedback
    end

  end

  #get feedback objects for user
  #takes created_for as string(username), and id of a feedback date object
  #returns PeerFeedback object
  def self.get_feedback_for_user_by_date(created_for, feedback_date_id)
    feedback = PeerFeedback.where(created_for: created_for,
                                  feedback_date_id: feedback_date_id)

    if feedback.length == 0
      return nil
    else
      return feedback
    end
  end

  #check if feedback is completed for feedback period
  #takes list of student objects, created_by as string(username) and id of feedback date object
  #returns true or false
  def self.check_feedback_completion(students_list, created_by, feedback_date_id)

    feedback_completed = true

    for i in 0...students_list.length
      current_feedback = PeerFeedback.where(created_by: created_by,
                                            created_for: students_list[i].username,
                                            feedback_date_id: feedback_date_id).first


      if current_feedback.nil?
        feedback_completed = false
        break
      end
      
      if current_feedback.status == "in_progress"
        feedback_completed = false
        break
      end
    end

    return feedback_completed

  end

  #get feedback for a ceratain feedback period for a team
  #takes team id and feedback date id
  #returns array of PeerFeedback objects
  def self.get_feedback_for_team_period(team_id, feedback_date_id)
    team_members = Team.get_current_team_members(team_id)

    result = []

    #get feedback for every team member
    for i in 0...team_members.length
      feedback_for_current_team_member = PeerFeedback.get_feedback_for_user_by_date(team_members[i].username, feedback_date_id)

      result.append(feedback_for_current_team_member)
    end

    return result
  end
end
