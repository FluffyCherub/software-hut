# == Schema Information
#
# Table name: user_teams
#
#  id               :bigint           not null, primary key
#  signed_agreement :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  team_id          :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_user_teams_on_team_id  (team_id)
#  index_user_teams_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe UserTeam, type: :model do
  
  before :all do
    
    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user4 = create(:user, givenname: 'Wendy', sn: 'Boby', username: 'vdas123', email: 'wboby2@sheffield.ac.uk')
    @user5 = create(:user, givenname: 'Winky', sn: 'Tom', username: 'vdq3333', email: 'wtom41@sheffield.ac.uk')
    @user6 = create(:user, givenname: 'Ada', sn: 'Wong', username: 'vvvqa23', email: 'awong5@sheffield.ac.uk')
    @user7 = create(:user, givenname: 'David', sn: 'Jon', username: 'gngj112', email: 'djon2@sheffield.ac.uk')
    @listmodule = create(:list_module)
    
    #create teams
    @team1 = create(:team, size: 3, list_module_id: @listmodule.id)
    @team2 = create(:team, size: 4, list_module_id: @listmodule.id)

    #fill the teams
    @userteam1 = create(:user_team, team_id: @team1.id, user_id: @user.id, signed_agreement: true)
    @userteam2 = create(:user_team, team_id: @team1.id, user_id: @user2.id, signed_agreement: true)
    @userteam3 = create(:user_team, team_id: @team1.id, user_id: @user3.id, signed_agreement: true)

    #fill the teams
    @userteam4 = create(:user_team, team_id: @team2.id, user_id: @user4.id, signed_agreement: false)
    @userteam5 = create(:user_team, team_id: @team2.id, user_id: @user5.id, signed_agreement: false)
    @userteam6 = create(:user_team, team_id: @team2.id, user_id: @user6.id, signed_agreement: false)
  end

  describe '#check_toa_completion' do
    it 'return true when team operating agreement is completed (all signed)' do
      expect(UserTeam.check_toa_completion(@team1.id)).to eq true
    end
    it 'return false when team operating agreement is not completed (NOT all signed)' do
      expect(UserTeam.check_toa_completion(@team2.id)).to eq false
    end
  end
  describe '#un_sign_toa' do
    it 'removes all signature from team members' do
      expect(@userteam1.signed_agreement).to eq true
      expect(@userteam2.signed_agreement).to eq true
      expect(@userteam3.signed_agreement).to eq true
      UserTeam.un_sign_toa(@team1.id)
      expect(UserTeam.where(id: @userteam1.id).first.signed_agreement).to eq false
      expect(UserTeam.where(id: @userteam2.id).first.signed_agreement).to eq false
      expect(UserTeam.where(id: @userteam3.id).first.signed_agreement).to eq false
    end
  end

  describe '#check_student_sign_status' do
    it 'returns false when user did sign the agreemnt' do
      expect(UserTeam.check_student_sign_status(@user.id, @team1.id)).to eq true
    end
    it 'returns false when user did NOT sign the agreemnt' do
      expect(UserTeam.check_student_sign_status(@user4.id, @team2.id)).to eq false
    end
    it 'returns false when user is not in the team' do
      # the function did not run when the user is not in the team
      expect(UserTeam.check_student_sign_status(@user.id, @team2.id)).to eq false
    end
  end

  
  describe '#is_student_in_team' do
    it 'returns true if student is in the team' do
      expect(UserTeam.is_student_in_team(@user.id, @team1.id)).to eq true
    end
    it 'returns false when student is not in the team' do
      expect(UserTeam.is_student_in_team(@user.id, @team2.id)).to eq false
    end
  end


  describe '#put_student_in_team' do
    it 'adds student into a team' do
      expect(UserTeam.is_student_in_team(@user7.id, @team2.id)).to eq false
      UserTeam.put_student_in_team(@user7.id, @team2.id)
      expect(UserTeam.is_student_in_team(@user7.id, @team2.id)).to eq true
    end
  end

  describe '#is_student_in_any_team_in_module' do
    it 'returns true if the student is in a team' do
      expect(UserTeam.is_student_in_any_team_in_module(@user.id, @listmodule.id)).to eq true
    end
    it 'returns false if the student is NOT in a team' do
      expect(UserTeam.is_student_in_any_team_in_module(@user7.id, @listmodule.id)).to eq false
    end
  end
end
