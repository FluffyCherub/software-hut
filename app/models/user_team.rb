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
class UserTeam < ApplicationRecord
  belongs_to :user
  belongs_to :team

  def self.check_toa_completion(team_id)
    num_of_students_in_team = UserTeam.where(team_id: team_id).length

    signatures = UserTeam.where(team_id: team_id)

    num_of_signs = 0

    for i in 0..(signatures.length-1)
      if signatures[i].signed_agreement == true
        num_of_signs = num_of_signs + 1
      end
    end

    if num_of_signs == num_of_students_in_team
      return true
    else
      return false
    end
  end

  def self.un_sign_toa(team_id)
    user_teams = UserTeam.where(team_id: team_id)

    user_teams.update(signed_agreement: false)
  end

  def self.check_student_sign_status(user_id, team_id)
    user_team = UserTeam.where(user_id: user_id, team_id: team_id).first.signed_agreement

    return user_team
  end
end
