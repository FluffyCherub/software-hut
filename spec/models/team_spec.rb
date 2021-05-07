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
    @user1 = FactoryBot.create :user, id: 1, username: 'abc12ef'
    @user2 = FactoryBot.create :user, id: 2, username: 'def34gh'
    @user3 = FactoryBot.create :user, id: 3, username: 'ghi56ij'
    @user4 = FactoryBot.create :user, id: 4, username: 'jkl78mn'
    @user5 = FactoryBot.create :user, id: 5, username: 'mno90pq'

    @listmodule1 = FactoryBot.create :list_module, id: 1

    @team1 = FactoryBot.create :team, id: 1, size: 6, list_module_id: 1
    @team2 = FactoryBot.create :team, id: 2, size: 5, list_module_id: 1, status: 'inactive'

    @usermodule1 = FactoryBot.create :user_list_module, id: 1, privilege: 'student',
    list_module_id: 1, user_id: 1
    @usermodule2 = FactoryBot.create :user_list_module, id: 2, privilege: 'student',
    list_module_id: 1, user_id: 2
    @usermodule3 = FactoryBot.create :user_list_module, id: 3, privilege: 'student',
    list_module_id: 1, user_id: 3
    @usermodule4 = FactoryBot.create :user_list_module, id: 4, privilege: 'teaching_assistant',
    list_module_id: 1, user_id: 4
    @usermodule5 = FactoryBot.create :user_list_module, id: 5, privilege: 'student',
    list_module_id: 1, user_id: 5

    @userteam1 = FactoryBot.create :user_team, id: 1, team_id: 1, user_id: 1
    @userteam2 = FactoryBot.create :user_team, id: 2, team_id: 1, user_id: 2
    @userteam3 = FactoryBot.create :user_team, id: 3, team_id: 2, user_id: 3

  end

  describe '#get_current_team_size' do
    it 'checks the current team size' do
      expect(Team.get_current_team_size(@team1.id)).to eq 2
    end
  end

  describe '#get_current_team_members' do
    it 'returns the current team members' do
      expect(Team.get_current_team_members(@team1.id).to_a).to eq [@user1, @user2]
    end
  end

  describe '#get_students_not_in_team_but_in_module' do
    it 'returns students not in team' do
      expect(Team.get_students_not_in_team_but_in_module(@listmodule1).first).to eq @user5
    end
  end

  describe '#get_students_not_in_inactive_team_but_in_module' do
    it 'returns students not in an inactive team' do
      expect(Team.get_students_not_in_inactive_team_but_in_module(@listmodule1).to_a).to eq [@user1, @user2, @user5]
    end
  end

  describe '#'
end
