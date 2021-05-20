# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
#  status         :string           default("waiting_for_approval")
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
  #connection to other tables in the database
  belongs_to :list_module

  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams

  has_many :problems, dependent: :destroy

  has_many :team_feedback_dates, dependent: :destroy
  has_many :feedback_dates, through: :team_feedback_dates

  #every team has multiple team meeting records
  has_many :tmrs, dependent: :destroy

  #one team operating agreement per team
  has_one_attached :document, dependent: :destroy

  #get the number of team members in team
  def self.get_current_team_size(team_id)
    current_team_size = User.joins(:teams).where("teams.id = ?", team_id).length
    return current_team_size
  end

  #get current team members of a team
  #takes team id(integer)
  #returns array of User objects
  def self.get_current_team_members(team_id)
    current_team_members = User.joins(:teams).where("teams.id = ?", team_id)

    return current_team_members
  end

  #get students who are in the module but arent connected to any team
  #takes module_id(integer)
  #returns array of User objects
  def self.get_students_not_in_team_but_in_module(module_id)
    teams_in_module = Team.where(list_module_id: module_id).pluck(:id)


    students_in_any_team_in_module = User.joins(:list_modules, :teams)
                                          .where("list_modules.id = ? AND
                                                  user_list_modules.privilege = ? AND
                                                  teams.id IN (?)",
                                                  module_id,
                                                  "student",
                                                  teams_in_module).group(:id).pluck(:id)
   
    if students_in_any_team_in_module.length == 0
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

  def self.get_students_not_in_inactive_team_but_in_module(module_id)
    students_in_any_team_in_module = User.joins(:list_modules, :teams)
                                         .where("teams.list_module_id = ? AND
                                                 user_list_modules.privilege = ? AND
                                                 teams.status = ?",
                                                 module_id,
                                                 "student",
                                                 "inactive").pluck(:id)

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

  def self.get_feedback_end_date(team_id)
    feedback_dates = FeedbackDate.joins(:teams)
                                  .where("teams.id = ?",
                                          team_id)
                                  .order("feedback_dates.end_date DESC")
    if feedback_dates.empty?
      return nil
    else
      return feedback_dates[0].end_date
    end

  end

  #run every minute, makes team go from active to inactive if the last feedback period ended
  def self.update_status()

    #get all the active teams in the system
    active_teams = Team.where("status = ? OR status = ?", "active", "waiting_for_approval")
    current_date = Time.now

    #get the last end date of feedback period for all active team
    active_teams.each do |team|
      end_date = get_feedback_end_date(team.id)

      #check if the active teams end date is in the past, if yes change teams status to inactive
      if end_date != nil
        if current_date - end_date > 0
          team.update(status: "inactive")
        end
      end
    end

  end

  def self.remove_student(user_id, team_id)
    user_team_connection = UserTeam.where(user_id: user_id,
                                          team_id: team_id)

    if user_team_connection != nil
      user_team_connection.destroy_all
    end
  end

  #check if team has at least one unsolved problem(red dot)
  def self.has_unsolved_problems(team_id)
    problems = Problem.where(team_id: team_id.to_i,
                             status: "unsolved")

    if problems.length > 0
      return true
    else
      return false
    end
  end

  #check if team has at least one assigned problem(yellow dot)
  def self.has_assigned_problems(team_id)
    problems = Problem.where(team_id: team_id.to_i,
                             status: "assigned")

    if problems.length > 0
      return true
    else
      return false
    end
  end
end
