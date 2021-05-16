# == Schema Information
#
# Table name: problems
#
#  id          :bigint           not null, primary key
#  assigned_to :string
#  created_by  :string
#  note        :string
#  solved_by   :string
#  solved_on   :datetime
#  status      :string           default("unsolved")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_problems_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

RSpec.describe Problem, type: :model do
  
  before :all do

    @user = create(:user, id: 1, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, id: 2, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, id: 3, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user4 = create(:user, id: 4, givenname: 'Wendy', sn: 'Boby', username: '123561', email: 'wboby2@sheffield.ac.uk')
    @listmodule = create(:list_module, id: 1)
    
    #create two teams
    @team1 = create(:team,  id: 1, size: 3, list_module_id: 1)
    @team2 = create(:team,  id: 2, size: 3, list_module_id: 1)

    #fill the teams
    @userteam1 = create(:user_team, id: 1, team_id: 1, user_id: 1)
    @userteam2 = create(:user_team, id: 2, team_id: 1, user_id: 2)
    @userteam3 = create(:user_team, id: 3, team_id: 1, user_id: 3)

    @problem1 = Problem.create(id: 1, team_id: 1)
    @problem2 = Problem.create(id: 2, team_id: 1, status: "assigned", assigned_to: @user4.username)
    @problem3 = Problem.create(id: 3, team_id: 1)
  end
  
  describe '#get_problems_for_team' do
    it 'return the list of problem of team i' do
      expect(Problem.get_problems_for_team(@team1.id)).to include(@problem1, @problem2, @problem3)
    end
    it 'return no problem when there are no problem' do
      expect(Problem.get_problems_for_team(@team2.id)).to eq []
    end
  end

  describe '#assign' do
    it 'assign the problem to a user' do
      expect(@problem1.assigned_to).to eq nil
      Problem.assign(@user4.username, @problem1.id)
      expect(Problem.where(id: @problem1.id)[0].assigned_to).to eq @user4.username
    end
  end

  describe '#change_status' do
    it 'changes the status of the problem to assigned' do
      expect(@problem1.status).to eq "unsolved"
      Problem.change_status(@problem1.id, "assigned")
      expect(Problem.where(id: @problem1.id)[0].status).to eq "assigned"
    end
    it 'changes the status of the problem to unsolved' do
      expect(@problem2.status).to eq "assigned"
      Problem.change_status(@problem2.id, "unsolved")
      expect(Problem.where(id: @problem2.id)[0].status).to eq "unsolved"
    end
  end

  describe '#solve' do
    it 'updates the problem i to be solved by user j at time t' do
      expect(@problem1.solved_by).to eq nil
      expect(@problem1.solved_on).to eq nil
      Problem.solve(@user4.username, @problem1.id, Time.new(2021, 5, 15))
      expect(Problem.where(id: @problem1.id)[0].solved_by).to eq @user4.username
      expect(Problem.where(id: @problem1.id)[0].solved_on).to eq Time.new(2021, 5, 15)
    end
  end

  describe '#is_assigned' do
    it 'returns true when the problem is assigned' do
      expect(Problem.is_assigned(@problem2.id)).to eq true
    end
    it 'returns false when the problem is NOT assigned' do
      expect(Problem.is_assigned(@problem3.id)).to eq false
    end
  end

  describe '#assigned_to' do
    it 'returns the user name when the problem is assigned' do
      expect(Problem.assigned_to(@problem2.id)).to eq @user4.username
    end
    it 'returns nil when the problem is NOT assigned' do
      expect(Problem.assigned_to(@problem3.id)).to eq nil
    end
  end
end
