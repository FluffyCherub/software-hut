# == Schema Information
#
# Table name: tmrs
#
#  id         :bigint           not null, primary key
#  status     :string           default("in_progress")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_tmrs_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

RSpec.describe Tmr, type: :model do
  
  before :all do

    @user = create(:user, id: 1, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, id: 2, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, id: 3, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user4 = create(:user, id: 4, givenname: 'Wendy', sn: 'Boby', username: '123561', email: 'wboby2@sheffield.ac.uk')
    @listmodule = create(:list_module, id: 1)
    
    #create teams
    @team1 = create(:team,  id: 1, size: 3, list_module_id: 1)
    @team2 = create(:team,  id: 2, size: 3, list_module_id: 1)
    @team3 = create(:team,  id: 3, size: 3, list_module_id: 1)
    @team4 = create(:team,  id: 4, size: 3, list_module_id: 1)

    #fill the teams
    @userteam1 = create(:user_team, team_id: 1, user_id: 1)
    @userteam2 = create(:user_team, team_id: 1, user_id: 2)
    @userteam3 = create(:user_team, team_id: 1, user_id: 3)

    @userteam4 = create(:user_team, team_id: 2, user_id: 4)

    @tmr = Tmr.create(team_id: 1)
    @tmr2 = Tmr.create(team_id: 2, status: "submitted")
    @tmr3 = Tmr.create(team_id: 3, status: "finished")

    @tmr_sign = create(:tmr_signature, signed_by: @user.username, tmr_id: @tmr.id)
    @tmr_sign2 = create(:tmr_signature, signed_by: @user2.username, tmr_id: @tmr.id)
    @tmr_sign3 = create(:tmr_signature, signed_by: @user3.username, tmr_id: @tmr.id)

    
    @team5 = create(:team,  id: 5, size: 3, list_module_id: 1)
    @tmr4 = Tmr.create(team_id: 5, status: "finished")
    @tmr5 = Tmr.create(team_id: 5, status: "finished")
    @tmr6 = Tmr.create(team_id: 5)
  end

  describe '#get_unfinished_tmr' do
    it 'return a unfinished team meeting record if a team meeting record is in progress' do
      expect(Tmr.get_unfinished_tmr(@team1.id)).to eq @tmr
    end
    
    it 'return a unfinished team meeting record if a team meeting record is submitted' do
      expect(Tmr.get_unfinished_tmr(@team2.id)).to eq @tmr2
    end
    it 'return no team meeting record if all team meeting record is finished' do
      expect(Tmr.get_unfinished_tmr(@team3.id)).to eq nil
    end
    it 'return no record if not exist' do
      expect(Tmr.get_unfinished_tmr(@team4.id)).to eq nil
    end
  end

  describe '#check_tmr_completion' do
    it 'returns true when team meeting record has signatures from all users' do
      expect(Tmr.check_tmr_completion(@tmr.id, @team1.id)).to eq true
    end
    
    it 'returns false when team meeting record does NOT have signatures from all users' do
      expect(Tmr.check_tmr_completion(@tmr2.id, @team2.id)).to eq false
    end
  end

  describe '#get_all_tmr_for_team' do
    it 'returns the list of finished team meeting records of team i' do
      expect(Tmr.get_all_tmr_for_team(@team5.id)).to include(@tmr4, @tmr5)
    end
    
    it 'returns no team records when there is no finished team meeting records' do
      expect(Tmr.get_all_tmr_for_team(@team1.id)).to eq []
    end
  end




end
