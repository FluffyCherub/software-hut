# == Schema Information
#
# Table name: tmr_signatures
#
#  id         :bigint           not null, primary key
#  signed_at  :datetime
#  signed_by  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tmr_id     :bigint           not null
#
# Indexes
#
#  index_tmr_signatures_on_tmr_id  (tmr_id)
#
# Foreign Keys
#
#  fk_rails_...  (tmr_id => tmrs.id)
#
require 'rails_helper'

RSpec.describe TmrSignature, type: :model do

  
  before :all do

    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user4 = create(:user, givenname: 'Wendy', sn: 'Boby', username: '123561', email: 'wboby2@sheffield.ac.uk')
    @listmodule = create(:list_module)
    
    #create teams
    @team1 = create(:team, size: 3, list_module_id: @listmodule.id)
    @team2 = create(:team, size: 3, list_module_id: @listmodule.id)

    #fill the teams
    @userteam1 = create(:user_team, team_id: @team1.id, user_id: @user.id)
    @userteam2 = create(:user_team, team_id: @team1.id, user_id: @user2.id)
    @userteam3 = create(:user_team, team_id: @team1.id, user_id: @user3.id)

    @userteam4 = create(:user_team, team_id: @team2.id, user_id: @user4.id)
    #create team meeting records with different status in each team
    @tmr = Tmr.create(team_id: @team1.id)
    @tmr2 = Tmr.create(team_id: @team2.id, status: "submitted")

    @tmr_sign = create(:tmr_signature, signed_by: @user.username, tmr_id: @tmr.id)
    @tmr_sign2 = create(:tmr_signature, signed_by: @user2.username, tmr_id: @tmr.id)
    @tmr_sign3 = create(:tmr_signature, signed_by: @user3.username, tmr_id: @tmr.id)

  end

  describe '#check_signature' do
    it 'return true when user i sign team meeting record j' do
      expect(TmrSignature.check_signature(@user.username, @tmr.id)).to eq true
    end
    it 'return false when user i NOT sign team meeting record j' do
      expect(TmrSignature.check_signature(@user4.username, @tmr.id)).to eq false
    end
    
  end

  describe '#get_tmr_signatures' do
    it 'return the list of signatures of a team meeting record' do
      expect(TmrSignature.get_tmr_signatures(@tmr.id)).to include(@tmr_sign, @tmr_sign2, @tmr_sign3)
    end
    it 'return empty list if no signatures exist' do
      expect(TmrSignature.get_tmr_signatures(@tmr2.id)).to eq []
    end
    
  end


end
