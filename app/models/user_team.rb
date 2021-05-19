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
  #connection to other database tables
  belongs_to :user
  belongs_to :team

  #check if the team operating agreement is completed for a given team
  #takes a team id(integer)
  #returns true or false
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

  #usingns a team operating agreement
  #takes team id(integer)
  #returns void
  def self.un_sign_toa(team_id)
    user_teams = UserTeam.where(team_id: team_id)

    user_teams.update(signed_agreement: false)
  end

  #check if student signed the team operating agreement
  #takes user id(integer) and team id(integer)
  #returns UserTeam object
  def self.check_student_sign_status(user_id, team_id)
    user_team = UserTeam.where(user_id: user_id, team_id: team_id).first

    if user_team == nil
      return false
    else
      return user_team.signed_agreement
    end
  end

  #puts a student in a team
  #takes student id(integer) and team_id(integer)
  #returns void
  def self.put_student_in_team(student_id, team_id)
    UserTeam.create(user_id: student_id,
                    team_id: team_id)
  end

  #check if student is in a team
  #takes student id(integer) and team id(integer)
  #returns true of false
  def self.is_student_in_team(student_id, team_id)
    check = UserTeam.where(user_id: student_id,
                   team_id: team_id)

    if check.length == 0
      return false
    else
      return true
    end
  end

  #check if student is in any team in the given module
  #takes student id(integer) and module id(integer)
  #returns true or false
  def self.is_student_in_any_team_in_module(student_id, module_id)
    check = UserTeam.joins(:team).where("user_teams.user_id = ? AND
                                         teams.list_module_id = ?",
                                         student_id,
                                         module_id)

    if check.length > 0
      return true
    else
      return false
    end
  end
end
