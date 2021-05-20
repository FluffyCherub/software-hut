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

    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user4 = create(:user, givenname: 'Wendy', sn: 'Boby', username: '123561', email: 'wboby2@sheffield.ac.uk')
    @listmodule = create(:list_module)
    
    #create teams
    @team1 = create(:team, size: 3, list_module_id: @listmodule.id)
    @team2 = create(:team, size: 3, list_module_id: @listmodule.id)
    @team3 = create(:team, size: 3, list_module_id: @listmodule.id)
    @team4 = create(:team, size: 3, list_module_id: @listmodule.id)

    #fill the teams
    @userteam1 = create(:user_team, team_id: @team1.id, user_id: @user.id)
    @userteam2 = create(:user_team, team_id: @team1.id, user_id: @user2.id)
    @userteam3 = create(:user_team, team_id: @team1.id, user_id: @user3.id)

    @userteam4 = create(:user_team, team_id: @team2.id, user_id: @user4.id)

    #create team meeting records with different status in each team
    @tmr = Tmr.create(team_id: @team1.id)
    @tmr2 = Tmr.create(team_id: @team2.id, status: "submitted")
    @tmr3 = Tmr.create(team_id: @team3.id, status: "finished")

    @tmr_sign = create(:tmr_signature, signed_by: @user.username, tmr_id: @tmr.id)
    @tmr_sign2 = create(:tmr_signature, signed_by: @user2.username, tmr_id: @tmr.id)
    @tmr_sign3 = create(:tmr_signature, signed_by: @user3.username, tmr_id: @tmr.id)

    
    @team5 = create(:team, size: 3, list_module_id: @listmodule.id)
    @tmr4 = Tmr.create(team_id: @team5.id, status: "finished")
    @tmr5 = Tmr.create(team_id: @team5.id, status: "finished")
    @tmr6 = Tmr.create(team_id: @team5.id)
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

  describe '#add_tmr' do
    # let(:file) { File.read("spec/fixtures/tmr_template.pdf") }
    # it 'adds the team meeting record to the team' do
    #   upload_file = Hash.new
    #   upload_file['datafile'] = file
    #   Tmr.add_tmr(@team1.id, file)
    # end
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
