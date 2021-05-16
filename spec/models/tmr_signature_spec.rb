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
