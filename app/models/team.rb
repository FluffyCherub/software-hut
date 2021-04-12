# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
#  toa_status     :string           default("in_progress")
#  topic          :string
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

  has_many :user_teams
  has_many :users, through: :user_teams

  #one team operating agreement per team
  has_one_attached :document

  #multiple team meeting record per team
  has_many_attached :tmrs


  #get the number of team members in team
  def self.get_current_team_size(team_id)
    current_team_size = User.joins(:teams).where("teams.id = ?", team_id).length
    return current_team_size
  end

  def self.get_current_team_members(team_id)
    current_team_members = User.joins(:teams).where("teams.id = ?", team_id)

    return current_team_members
  end

end
