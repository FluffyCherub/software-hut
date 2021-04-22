# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
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
class Team < ApplicationRecord
  belongs_to :list_module

  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams

  has_many :problems, dependent: :destroy

  #one team operating agreement per team
  has_one_attached :document, dependent: :destroy


  #get the number of team members in team
  def self.get_current_team_size(team_id)
    current_team_size = User.joins(:teams).where("teams.id = ?", team_id).length
    return current_team_size
  end

  def self.get_current_team_members(team_id)
    current_team_members = User.joins(:teams).where("teams.id = ?", team_id)

    return current_team_members
  end

  def self.get_students_not_in_team_but_in_module(module_id)
    

    students_in_any_team_in_module = User.joins(:list_modules, :teams)
                                         .where("list_modules.id = ? AND 
                                                 user_list_modules.privilege = ?",
                                                 module_id,
                                                 "student").pluck(:id)


    if students_in_any_team_in_module[0] == nil
      students_in_module = User.joins(:list_modules)
                               .where("list_modules.id = ? AND 
                                       user_list_modules.privilege = ?",
                                       module_id,
                                       "student"
                                       )
    else
      students_in_module = User.joins(:list_modules)
                               .where("list_modules.id = ? AND 
                                      user_list_modules.privilege = ? AND
                                      users.id NOT IN (?)",
                                      module_id,
                                      "student",
                                      students_in_any_team_in_module)
    end
    
    return students_in_module
  end

end
