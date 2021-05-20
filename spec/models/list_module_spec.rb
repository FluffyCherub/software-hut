# == Schema Information
#
# Table name: list_modules
#
#  id                :bigint           not null, primary key
#  code              :string
#  created_by        :string
#  description       :string
#  level             :integer
#  mailmerge_message :string           default("")
#  name              :string
#  semester          :string
#  team_type         :string           default("random")
#  years             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'
require 'date'

describe ListModule do

  before :all do
    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user4_in_inactive_team = create(:user, username: 'abcde21', email: 'abc21@sheffield.ac.uk')
    @user_module_leader = create(:user, username: 'modleader', email: 'mod21@sheffield.ac.uk')
    @listmodule = create(:list_module, code: 'COM101', name: 'Intro to Java',
       level: 1, created_at: DateTime.now(), updated_at: DateTime.now(), years: '2019-2020')

    @listmodule2 = create(:list_module, code: 'COM303', name: 'Advanced algorithm',
      level: 3, created_at: DateTime.now(), updated_at: DateTime.now(), years: '2020-2021')
    @listmodule3 = create(:list_module, code: 'COM404', name: 'Intro to ruby',
      level: 3, created_at: DateTime.now(), updated_at: DateTime.now(), years: '2020-2021')

    @usermodule = create(:user_list_module, privilege: 'student', created_at: DateTime.now(), \
      updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user.id)
    @usermodule2 = create(:user_list_module, privilege: 'teaching_assistant', created_at: DateTime.now(), \
      updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user2.id)
    @usermodule3 = create(:user_list_module, privilege: 'student', created_at: DateTime.now(), \
      updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user4_in_inactive_team.id)
    @usermodule4 = create(:user_list_module, privilege: 'module_leader', created_at: DateTime.now(), \
      updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user_module_leader.id)


    @team1 = FactoryBot.create :team, size: 6, list_module_id: @listmodule.id, status: 'waiting_for_approval'
    @team2 = FactoryBot.create :team, size: 6, list_module_id: @listmodule.id, status: 'inactive'
    @team3 = FactoryBot.create :team, size: 6, list_module_id: @listmodule2.id, status: 'waiting_for_approval'

    @team4 = FactoryBot.create :team, size: 6, list_module_id: @listmodule3.id, status: 'active'
    @team5 = FactoryBot.create :team, size: 6, list_module_id: @listmodule3.id, status: 'active'


    # @usermodule = FactoryBot.create :user_list_module, privilege: 'student',
    # list_module_id: @listmodule.id, user_id: @user.id

    @old_feedback_date = FeedbackDate.create(start_date: Time.now - 1.months, end_date: Time.now, list_module_id: @listmodule.id)
    @feedback_date = FeedbackDate.create(start_date: Time.now + 1.hours, end_date: Time.now + 1.months, list_module_id: @listmodule.id)
    @feedback_date1 = FeedbackDate.create(start_date: Time.now + 1.months, end_date: Time.now + 2.months, list_module_id: @listmodule.id)

    @userteam1 = FactoryBot.create :user_team, team_id: @team1.id, user_id: @user.id
    # @userteam2 = FactoryBot.create :user_team, team_id: @team2.id, user_id: @user2.id
    @userteam3 = FactoryBot.create :user_team, team_id: @team2.id, user_id: @user4_in_inactive_team.id
  end

  describe '#generate_years' do
    it 'generate academic years based on current year' do
      expect(ListModule.generate_years(2021, 3)).to include("2021/2022", "2022/2023", "2023/2024")
    end
  end

  describe '#users_in_module' do
    it 'returns Users in module 101' do
      expect(ListModule.users_in_module(@listmodule.id).to_a).to include(@user, @user2)
    end
  end

  describe '#students_in_module' do
    it 'returns all students in module 101' do
      expect(ListModule.students_in_module(@listmodule.id).first).to eq @user
    end
  end

  describe '#privilege_for_module' do
    it 'returns privilege of Jean Doe in module 101' do
      expect(ListModule.privilege_for_module(@user2.username, @listmodule.id)).to eq 'teaching_assistant'
    end
    it 'returns privilege of a student who is not within the module' do
      # the function did not run
      expect(ListModule.privilege_for_module(@user3.username, @listmodule.id)).to eq nil
    end
  end

  describe '#num_students_in_mod' do
    it 'returns number of students in module 101' do
      expect(ListModule.num_students_in_mod(@listmodule.id)).to eq 2
    end
  end

  describe '#set_team_type' do
    it 'sets the team type of self_select' do
      ListModule.set_team_type(@listmodule.id, 'self_select')
      expect(ListModule.where(id: @listmodule.id).first.team_type).to eq 'self_select'
    end
  end

  describe '#get_mod_name_from_id' do
    it 'returns module name for module 101' do
      expect(ListModule.get_mod_name_from_id(@listmodule.id)).to eq 'Intro to Java'
    end
  end


  describe '#approve_teams' do
    it 'sets teams that are waiting for approval to active' do
      expect(@team1.status).to eq 'waiting_for_approval'
      ListModule.approve_teams(@listmodule.id)
      expect(Team.find(@team1.id).status).to eq 'active'
    end
    it 'will NOT set teams that inactive to active' do
      expect(@team2.status).to eq 'inactive'
      ListModule.approve_teams(@listmodule.id)
      expect(Team.find(@team2.id).status).to eq 'inactive'
    end
    it 'will NOT set teams that are in other module to active' do
      expect(@team3.status).to eq 'waiting_for_approval'
      ListModule.approve_teams(@listmodule.id)
      expect(Team.find(@team3.id).status).to eq 'waiting_for_approval'
    end
  end

  describe '#all_approved' do
    it 'returns true if all teams in the module are approved' do
      expect(ListModule.all_approved(@listmodule3.id)).to eq true
    end
    it 'return false if not all teams in the module are approved' do
      expect(ListModule.all_approved(@listmodule.id)).to eq false
    end
  end


  describe '#has_active_teams' do
    it 'returns true if it has active teams' do
      expect(ListModule.has_active_teams(@listmodule3.id)).to eq true
    end
    it 'return false if it does not have any active team' do
      expect(ListModule.has_active_teams(@listmodule.id)).to eq false
    end
  end

  
  describe '#get_future_feedback_periods' do
    it 'returns the list of future feedback date of the module' do
      results = ListModule.get_future_feedback_periods(@listmodule.id, Time.now)
      expect(results).to include(@feedback_date, @feedback_date1)
      expect(results).not_to  include(@old_feedback_date)
    end
  end

  
  describe '#get_teams_for_user' do
    it 'return the teams the user is in' do
      expect(ListModule.get_teams_for_user(@listmodule.id, @user.username)).to include(@team1)
      expect(ListModule.get_teams_for_user(@listmodule.id, @user4_in_inactive_team.username)).to include(@team2)
    end
  end

  describe '#get_inactive_teams_for_user' do
    it 'returns [] if the user does NOT in an inactive team' do
      expect(ListModule.get_inactive_teams_for_user(@listmodule.id, @user.username)).to eq []
    end
    it 'returns the inactive teams the user is in' do
      expect(ListModule.get_inactive_teams_for_user(@listmodule.id, @user4_in_inactive_team.username)).to include(@team2)
    end
  end

  describe '#get_modules_for_years' do
    it 'returns the list of modules of year i of user j' do
      years = '2019-2020'
      expect(ListModule.get_modules_for_years(years, @user.username)).to include(@listmodule)
    end
    it 'returns the empty list if the user has no module in that yeare' do
      years = '2020-2021'
      expect(ListModule.get_modules_for_years(years, @user.username)).to eq []
    end
  end
    
  describe '#get_inactive_modules_for_years' do
    it 'returns the list of modules of year i of user j if the user is in an inactive team' do
      years = '2019-2020'
      # there is an error in sql clause: missing AND
      expect(ListModule.get_inactive_modules_for_years(years, @user.username)).to include(@listmodule)
    end
  end


  describe '#get_mod_leads' do
    it 'returns the modue leader of the module' do
      expect(ListModule.get_mod_leads(@listmodule)).to include(@user_module_leader)
    end
    it 'returns [] of the module when there is no module leader' do
      expect(ListModule.get_mod_leads(@listmodule2)).to eq []
    end
  end

  
  describe '#get_ta_and_mod_lead' do
    it 'returns the modue leader of the module' do
      expect(ListModule.get_ta_and_mod_lead(@listmodule)).to include(@user_module_leader)
    end
    it 'returns the teaching assistance of the module' do
      expect(ListModule.get_ta_and_mod_lead(@listmodule)).to include(@user2)
    end
    it 'returns [] of the module when there is no module leader nor teaching assistance' do
      expect(ListModule.get_ta_and_mod_lead(@listmodule2)).to eq []
    end
  end

  describe '#get_ta_and_mod_lead_names_username' do
    it 'returns the formatted name of the modue leader of the module' do
      name_format = @user_module_leader.givenname + " " + @user_module_leader.sn + " - " + @user_module_leader.username
      expect(ListModule.get_ta_and_mod_lead_names_username(@listmodule)).to include(name_format)
    end
    it 'returns the formatted name of the teaching assistance of the module' do
      name_format = @user2.givenname + " " + @user2.sn + " - " + @user2.username
      expect(ListModule.get_ta_and_mod_lead_names_username(@listmodule)).to include(name_format)
    end
    it 'returns [] of the module when there is no module leader nor teaching assistance' do
      expect(ListModule.get_ta_and_mod_lead_names_username(@listmodule2)).to eq []
    end
  end
end
#RSpec.describe ListModule, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"
#end
