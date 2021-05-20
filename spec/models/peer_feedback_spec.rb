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
require 'rails_helper'

RSpec.describe PeerFeedback, type: :model do
  before :all do
    
    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user9 = create(:user, givenname: 'Wendy', sn: 'Boby', username: '123561', email: 'wboby2@sheffield.ac.uk')
    @listmodule = create(:list_module)
    
    #create team
    @team1 = create(:team, size: 3, list_module_id: @listmodule.id)
    @team2 = create(:team, size: 3, list_module_id: @listmodule.id)

    #fill the teams
    @userteam1 = create(:user_team, team_id: @team1.id, user_id: @user.id)
    @userteam2 = create(:user_team, team_id: @team1.id, user_id: @user2.id)
    @userteam3 = create(:user_team, team_id: @team1.id, user_id: @user3.id)
    @userteam3 = create(:user_team, team_id: @team2.id, user_id: @user9.id)


    # creates a feedback date that is going to end soon (so it has to send a reminder)
    @feedback_date = FeedbackDate.create( created_at: Time.now ,updated_at: Time.now, end_date: Time.now + 1.hours, list_module_id: @listmodule.id)

    @team_feedback_date1 = create(:team_feedback_date, feedback_date_id: @feedback_date.id, team_id: @team1.id)

    @feedback13 = create(:peer_feedback, created_by: @user.username, created_for: @user3.username, feedback_date_id: @feedback_date.id,\
      attendance:1, attitude:2, qac:3, communication:4, collaboration:4, leadership:2, ethics:3, \
      appreciate_edited: 'good job!', request_edited:'no'
      )
    @feedback23 = create(:peer_feedback, created_by: @user2.username, created_for: @user3.username, feedback_date_id: @feedback_date.id,\
      attendance:3, attitude:3, qac:3, communication:4, collaboration:4, leadership:2, ethics:3, status: 'finished', \
      appreciate_edited: 'good job2!', request_edited:'no2')
    @feedback21 = create(:peer_feedback, created_by: @user2.username, created_for: @user.username, feedback_date_id: @feedback_date.id,\
      attendance:3, attitude:3, qac:3, communication:4, collaboration:4, leadership:2, ethics:3, status: 'finished')
    @feedback22 = create(:peer_feedback, created_by: @user2.username, created_for: @user2.username, feedback_date_id: @feedback_date.id,\
      attendance:3, attitude:3, qac:3, communication:4, collaboration:4, leadership:2, ethics:3, status: 'finished')
      
    @feedback31 = create(:peer_feedback, created_by: @user3.username, created_for: @user.username, feedback_date_id: @feedback_date.id,\
    attendance:4, attitude:4, qac:4, communication:4, collaboration:4, leadership:4, ethics:4, status: 'finished')
    @feedback32 = create(:peer_feedback, created_by: @user3.username, created_for: @user2.username, feedback_date_id: @feedback_date.id,\
      attendance:3, attitude:3, qac:3, communication:4, collaboration:4, leadership:2, ethics:3, status: 'finished')
    @feedback33 = create(:peer_feedback,  created_by: @user3.username, created_for: @user3.username, feedback_date_id: @feedback_date.id,\
      attendance:3, attitude:3, qac:3, communication:4, collaboration:4, leadership:2, ethics:3, status: 'in_progress')

    # unused feedback date (only for checking edge cases)
    @feedback_date2 = create(:feedback_date, created_at: Time.new(2021, 5, 22) ,updated_at: Time.new(2021, 5, 29), list_module_id: @listmodule.id)

    # feedback date that is currenly active (but haven't sent a reminder about it has opened)
    @feedback_date3 = FeedbackDate.create(start_date: Time.now - 1.days, end_date: Time.now + 1.days, list_module_id: @listmodule.id, period_open_sent: false)
    @team_feedback_date2 = create(:team_feedback_date, feedback_date_id: @feedback_date3.id, team_id: @team2.id)
    @feedback99 = create(:peer_feedback, created_by: @user9.username, created_for: @user9.username, feedback_date_id: @feedback_date3.id,\
      attendance:1, attitude:2, qac:3, communication:4, collaboration:4, leadership:2, ethics:3
      )
  end
  describe '#feedback_to_int' do
    it 'return the id of the feedback type' do
      expect(PeerFeedback.feedback_to_int("unsatisfactory")).to eq 1
      expect(PeerFeedback.feedback_to_int("needs_improvement")).to eq 2
      expect(PeerFeedback.feedback_to_int("meets_expectations")).to eq 3
      expect(PeerFeedback.feedback_to_int("exceeds_expectations")).to eq 4
    end
    it 'return nil id if no/false input is given' do
      expect(PeerFeedback.feedback_to_int()).to eq nil
      expect(PeerFeedback.feedback_to_int('anytThing')).to eq nil
    end
  end
  describe '#get_feedback_array_for_user' do
    it 'return the list of feedback items from user i to user j at time t' do
      expect(PeerFeedback.get_feedback_array_for_user(@user.username, @user3.username, @feedback_date.id)).to eq \
        [@feedback13.attendance, @feedback13.attitude, @feedback13.qac, @feedback13.communication, @feedback13.collaboration, @feedback13.leadership, @feedback13.ethics]

    end
    it 'return nil when no feedback matches the query' do
      expect(PeerFeedback.get_feedback_array_for_user(@user.username, @user2.username, @feedback_date.id)).to eq nil
    end
  end
  describe '#get_feedback_for_user' do
    it 'return feedback object from user i to user j at time t' do
      expect(PeerFeedback.get_feedback_for_user(@user.username, @user3.username, @feedback_date.id)).to eq [@feedback13]
    end
    it 'return nil when no feedback matches the query' do
      expect(PeerFeedback.get_feedback_for_user(@user.username, @user2.username, @feedback_date.id)).to eq nil
    end
  end
  describe '#get_feedback_for_user_by_date' do
    it 'return feedback object to user j at time t' do
      expect(PeerFeedback.get_feedback_for_user_by_date(@user3.username, @feedback_date.id)).to include(@feedback13, @feedback23)
    end
    it 'return nil when no feedback matches the query' do
      expect(PeerFeedback.get_feedback_for_user_by_date(@user9.username, @feedback_date.id)).to eq nil
    end
  end
  
  describe '#check_feedback_completion' do
    it 'return true when all students complete feedback from user i' do
      student_list = [@user, @user2, @user3]
      expect(PeerFeedback.check_feedback_completion(student_list, @user2.username, @feedback_date.id)).to eq true
    end
    it 'return false when exist students NOT given feedback to another student' do
      student_list = [@user, @user2, @user3]
      expect(PeerFeedback.check_feedback_completion(student_list, @user.username, @feedback_date.id)).to eq false
    end
    it 'return false when exist students feedback in progress' do
      student_list = [@user, @user2, @user3]
      expect(PeerFeedback.check_feedback_completion(student_list, @user3.username, @feedback_date.id)).to eq false
    end
    it 'return true when empty student list given' do
      expect(PeerFeedback.check_feedback_completion([], @user.username, @feedback_date.id)).to eq true
    end
  end

  describe '#get_feedback_for_team_period' do
    it 'returns the list of peer feebdback of the team within the period' do
      expect(PeerFeedback.get_feedback_for_team_period(@team1.id, @feedback_date.id).flatten).to \
        include(@feedback13, @feedback21, @feedback22, @feedback23, @feedback31, @feedback32, @feedback33)
    end
  end

  describe '#array_int_to_feedback' do
    it 'returns a simple feedback given the int array' do
      expect(PeerFeedback.array_int_to_feedback([1.4, 1, 3, 2, 2, 2, 2, 4]).flatten).to \
        eq [nil, "Unsatisfactory", "Meets Expectations", "Needs Improvement", "Needs Improvement", "Needs Improvement", "Needs Improvement", "Exceeds Expectations"]
    end
    it 'returns nil when it does not recieve the feedback' do
      expect(PeerFeedback.array_int_to_feedback([-1,-1,-1,-1,-1,-1,-1,-1]).flatten).to \
        eq [nil,nil,nil,nil,nil,nil,nil,nil,]
    end
    it 'returns correct output given empty array' do
      expect(PeerFeedback.array_int_to_feedback([]).flatten).to \
        eq []
    end
  end

  describe '#array_int_to_feedback_long' do
    it 'return the text of the feedback' do
      expect(PeerFeedback.array_int_to_feedback_long(
        [2.4,1, 3, 2, 2, 2, 2, 4]
      )).to eq [
        ["Attendance and Punctuality", "You have had one of more absences or late arrivals to scheduled team activities and have not explained these to the team. You may have let other commitments impact your contribution. Your performance is detracting from the team’s work."],
        ["Attitude and Commitment",     "You bring a positive attitude to the team, are generally focused, and work hard most of the time. You you are undertaking your fair share of the workload, and complete work to the agreed schedule."],
        ["Quality, accuracy and completeness",     "You have not made as much progress as you could have done with your contributions. Work that has been completed is on the right lines, but needs checking for basic errors. You need to put in extra effort to complete work to the standard agreed in our team vision/mission."],
        ["Communication",    "Your contribution is patchy with minimal input to discussions and generally poor responses to messages. You do not always listen effectively to others, and need to think about how you share important information the rest of the team needs to succeed."],
        ["Collaboration",     "You come across abrupt and offhand, and tend to work in isolation without consulting the team. You are not receptive to feedback from others. You may sometimes cause conflicts within the team and could do more to help the team work together."],
        ["Leadership",     "You did not make much contribution to setting team goals, and focus on your own contributions rather than the overall objectives. Your input to idea generation and problem solving is minimal."],
        ["Professionalism and ethics",     "You are a role model for others, behaving professionally and ethically even in difficult circumstances. You take great care to ensure that your interactions with others are positive and do not have a negative impact."]
      ]
    end
    it 'return a text representing no feedback is received when there is no feedback' do
      expect(PeerFeedback.array_int_to_feedback_long(
        [2.4, -1, -1, -1, -1, -1, -1, -1]
      )).to eq [
        ["Attendance and Punctuality", "You received no feedback for this criteria."],
        ["Attitude and Commitment",  "You received no feedback for this criteria."],
        ["Quality, accuracy and completeness", "You received no feedback for this criteria."],
        ["Communication", "You received no feedback for this criteria."],
        ["Collaboration", "You received no feedback for this criteria."],
        ["Leadership", "You received no feedback for this criteria."],
        ["Professionalism and ethics", "You received no feedback for this criteria."]
      ]
    end
  end


  describe '#get_average_feedback_data' do
    it 'return the correct output (average feedback, number of period, feedback id, ...) of user i in team j' do
      result = PeerFeedback.get_average_feedback_data(@user.username, @team1.id)
      expect(result[0]).to eq [[3.5714285714285716], [3.5], [3.5], [3.5], [4.0], [4.0], [3.0], [3.5]]
      expect(result[1]).to eq 1
      expect(result[2]).to eq [4, 4, 4, 4, 4, 4, 3, 4]
      expect(result[3]).to include(@user2, @user3) # users in team without the query user
      expect(result[4]).to include(@user, @user2, @user3) # users in team
    end
    it 'return the empty output when user i not in team j' do
      result = PeerFeedback.get_average_feedback_data(@user9.username, @team1.id)
      for i in 0...8
        expect(result[0][i][0].to_f.nan?).to eq true
      end
      expect(result[1]).to eq 1
      for i in 0...8
        expect(result[2][i].to_f.nan?).to eq true
      end
      expect(result[3]).to include(@user, @user2, @user3)
      expect(result[4]).to include(@user, @user2, @user3)
    end
  end

  describe '#get_average_feedback_data_for_period' do
    it 'return the average feedback of user i in team j at time k' do
      expect(PeerFeedback.get_average_feedback_data_for_period(@user.username, @team1.id, @feedback_date)).to eq [4, 4, 4, 4, 4, 4, 3, 4]

    end
    it 'return [-1, -1, -1, -1, -1, -1, -1, -1] if there is no feedback of user i in team j at time k' do
      results = PeerFeedback.get_average_feedback_data_for_period(@user.username, @team1.id, @feedback_date2)
      nan = Float::NAN
      expect(results).to eq [-1, -1, -1, -1, -1, -1, -1, -1]
    end
  end

  
  describe '#get_appreciate_request_for_student' do
    it 'return the appreciate/request from other students in the team' do
      expect(PeerFeedback.get_appreciate_request_for_student(@user3.username, @team1.id, @feedback_date).flatten).to include("good job2!","good job!", "no2","no")
    end
    it 'return an empty feedback if no appreciate/request get' do
      expect(PeerFeedback.get_appreciate_request_for_student(@user.username, @team1.id, @feedback_date)).to eq [["", ""], ["", ""]]
    end
  end

  describe '#get_appreciate_request_for_student' do
    it 'return the appreciate/request from other students in the team' do
      expect(PeerFeedback.get_appreciate_request_for_student(@user3.username, @team1.id, @feedback_date).flatten).to include("good job2!","good job!", "no2","no")
    end
    it 'return an empty feedback if no appreciate/request get' do
      expect(PeerFeedback.get_appreciate_request_for_student(@user.username, @team1.id, @feedback_date)).to eq [["", ""], ["", ""]]
    end
  end

  
  describe '#get_appreciate_request_for_student' do
    it 'return the appreciate/request from other students in the team' do
      expect(PeerFeedback.get_appreciate_request_for_student(@user3.username, @team1.id, @feedback_date).flatten).to include("good job2!","good job!", "no2","no")
    end
    it 'return an empty feedback if no appreciate/request get' do
      expect(PeerFeedback.get_appreciate_request_for_student(@user.username, @team1.id, @feedback_date)).to eq [["", ""], ["", ""]]
    end
  end

  
  describe '#remind' do
    it 'sends an email to the user, and after that it sets the reminder sent flag to true' do
      expect(@feedback_date.reminder_sent).to eq false
      # I think the where clause return a list of feedback, so feedback.nil? cannot capture the case when there are no feedback received
      PeerFeedback.remind()
      expect(FeedbackDate.where(id: @feedback_date.id).first.reminder_sent).to eq true
    end
  end

  describe '#feedback_period_open' do
    it 'opens a feedback period that is currently active (but havent sent an email to remind users)' do
      expect(@feedback_date3.period_open_sent).to eq false
      PeerFeedback.feedback_period_open()
      expect(FeedbackDate.where(id: @feedback_date3.id).first.period_open_sent).to eq true
    end
  end
end
