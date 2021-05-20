# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
#  status         :string           default("waiting_for_approval")
#  toa_status     :string           default("in_progress")
#  topic          :string           default("none")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  list_module_id :bigint
#
# Indexes
#
#  index_teams_on_list_module_id  (list_module_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_module_id => list_modules.id)
#
require 'rails_helper'

describe Team do
  before :all do
    #create some sample users
    @user1 = FactoryBot.create :user, username: 'abc12ef'
    @user2 = FactoryBot.create :user, username: 'def34gh'
    @user3 = FactoryBot.create :user, username: 'ghi56ij'
    @user4 = FactoryBot.create :user, username: 'jkl78mn'
    @user5 = FactoryBot.create :user, username: 'mno90pq'

    #create a module
    @listmodule1 = FactoryBot.create :list_module
    @listmodule2 = FactoryBot.create :list_module

    #create teams
    @team1 = FactoryBot.create :team, size: 6, list_module_id: @listmodule1.id
    @team2 = FactoryBot.create :team, size: 5, list_module_id: @listmodule1.id, status: 'inactive'
    @team3 = FactoryBot.create :team, size: 5, list_module_id: @listmodule1.id # a team with an old feedback date
    @team4 = FactoryBot.create :team, size: 5, list_module_id: @listmodule1.id, status: 'inactive' # a team with an unsolved problem
    @team5 = FactoryBot.create :team, size: 5, list_module_id: @listmodule1.id, status: 'inactive' # a team with an assigned problem
    @team6 = FactoryBot.create :team, size: 5, list_module_id: @listmodule1.id, status: 'inactive' # a team with a solved problem

    #create 4 students and a TA
    @usermodule1 = FactoryBot.create :user_list_module, privilege: 'student',
    list_module_id: @listmodule1.id, user_id: @user1.id
    @usermodule2 = FactoryBot.create :user_list_module, privilege: 'student',
    list_module_id: @listmodule1.id, user_id: @user2.id
    @usermodule3 = FactoryBot.create :user_list_module, privilege: 'student',
    list_module_id: @listmodule1.id, user_id: @user3.id
    @usermodule4 = FactoryBot.create :user_list_module,  privilege: 'teaching_assistant',
    list_module_id: @listmodule1.id, user_id: @user4.id
    @usermodule5 = FactoryBot.create :user_list_module, privilege: 'student',
    list_module_id: @listmodule1.id, user_id: @user5.id

    #fill the two teams
    @userteam1 = FactoryBot.create :user_team, team_id: @team1.id, user_id: @user1.id
    @userteam2 = FactoryBot.create :user_team, team_id: @team1.id, user_id: @user2.id
    @userteam3 = FactoryBot.create :user_team, team_id: @team2.id, user_id: @user3.id

    #create two feeback windows
    @feedback_date1 = FactoryBot.create :feedback_date, start_date: Time.new(2021, 5, 8),
    end_date: Time.new(2021, 6, 8), list_module_id: @listmodule1.id
    @feedback_date2 = FactoryBot.create :feedback_date, start_date: Time.new(2021, 7, 8),
    end_date: Time.new(2021, 9, 8), list_module_id: @listmodule1.id
    
    @feedback_date3 = FactoryBot.create :feedback_date, start_date: Time.new(2020, 1, 8),
    end_date: Time.new(2020, 2, 8), list_module_id: @listmodule1.id

    #add feedback windows to team 1
    @team_feedback_date1 = FactoryBot.create :team_feedback_date, feedback_date_id: @feedback_date1.id, team_id: @team1.id
    @team_feedback_date2 = FactoryBot.create :team_feedback_date, feedback_date_id: @feedback_date2.id, team_id: @team1.id
    
    #add an old feedback windows to team 3
    @team_feedback_date3 = FactoryBot.create :team_feedback_date, feedback_date_id: @feedback_date3.id, team_id: @team3.id

    #assign problem with different status to teams
    @problem1 = FactoryBot.create :problem, team_id: @team4.id, status: "unsolved"
    @problem2 = FactoryBot.create :problem, team_id: @team5.id, status: "assigned"
    @problem3 = FactoryBot.create :problem, team_id: @team6.id, status: "solved"

  end

  describe '#get_current_team_size' do
    it 'checks the current team size' do
      expect(Team.get_current_team_size(@team1.id)).to eq 2
    end
  end

  describe '#get_current_team_members' do
    it 'returns the current team members' do
      expect(Team.get_current_team_members(@team1.id).to_a).to include(@user1, @user2)
    end
  end

  describe '#get_students_not_in_team_but_in_module' do
    it 'returns students not in team' do
      expect(Team.get_students_not_in_team_but_in_module(@listmodule1).first).to eq @user5
    end
  end

  describe '#get_students_not_in_inactive_team_but_in_module' do
    it 'returns students not in an inactive team' do
      expect(Team.get_students_not_in_inactive_team_but_in_module(@listmodule1).to_a).to include(@user1, @user2, @user5)
    end
    it 'returns empties for a module with no students' do
      expect(Team.get_students_not_in_inactive_team_but_in_module(@listmodule2).to_a).to eq []
    end
  end

  describe '#get_feedback_end_date' do
    it 'returns very last end date for team 1 feedback' do
      expect(Team.get_feedback_end_date(@team1.id)).to eq @feedback_date2.end_date
    end
    it 'returns very last end date for team 2 feedback' do
      expect(Team.get_feedback_end_date(@team2.id)).to eq nil
    end
  end



  describe '#update_status' do
    it 'check if the status of a team with old feedback end date is changed to inactive' do
      expect(@team3.status).to eq 'waiting_for_approval'
      Team.update_status()
      expect(Team.where(id: @team3.id).first.status).to eq 'inactive'
    end
    
    it 'check if the status of a team with a current feedback end date is not updated' do
      expect(@team1.status).to eq 'waiting_for_approval'
      Team.update_status()
      expect(Team.where(id: @team1.id).first.status).to eq 'waiting_for_approval'
    end
  end

  describe '#remove_student' do
    it 'remove a student from a team' do
      expect(Team.get_current_team_members(@team1.id).to_a).to include(@user1, @user2)
      Team.remove_student(@user1.id, @team1.id)
      expect(Team.get_current_team_members(@team1.id).to_a).to include(@user2)
    end
    
    it 'no error when removing a student who is not in the team' do
      expect(Team.get_current_team_members(@team1.id).to_a).not_to include(@user3)
      Team.remove_student(@user3.id, @team1.id)
      expect(Team.get_current_team_members(@team1.id).to_a).not_to include(@user3)
    end
  end

  
  describe '#has_unsolved_problems' do
    it 'return true when there are unsolved problem in the team' do
      expect(Team.has_unsolved_problems(@team4.id)).to eq true
    end
    it 'return false when there are only assigned problem in the team' do
      expect(Team.has_unsolved_problems(@team5.id)).to eq false
    end
    it 'return false when there are only solved problem in the team' do
      expect(Team.has_unsolved_problems(@team6.id)).to eq false
    end
    it 'return false when there are no problem in the team' do
      expect(Team.has_unsolved_problems(@team1.id)).to eq false
    end
  end

  describe '#has_assigned_problems' do
    it 'return true when there are assigned problem in the team' do
      expect(Team.has_assigned_problems(@team5.id)).to eq true
    end
    it 'return false when there are only unsolved problem in the team' do
      expect(Team.has_assigned_problems(@team4.id)).to eq false
    end
    it 'return false when there are only solved problem in the team' do
      expect(Team.has_assigned_problems(@team6.id)).to eq false
    end
    it 'return false when there are no problem in the team' do
      expect(Team.has_assigned_problems(@team1.id)).to eq false
    end
  end
end
