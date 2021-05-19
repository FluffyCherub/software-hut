# == Schema Information
#
# Table name: problems
#
#  id          :bigint           not null, primary key
#  assigned_to :string
#  created_by  :string
#  note        :string
#  solved_by   :string
#  solved_on   :datetime
#  status      :string           default("unsolved")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  team_id     :bigint
#
# Indexes
#
#  index_problems_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class Problem < ApplicationRecord
  belongs_to :team

  #get array of problems for a team
  #takes team id(integer)
  #returns array of Problem objects
  def self.get_problems_for_team(team_id)
    problems = Problem.where(team_id: team_id)

    return problems
  end

  #assign user to a problem
  #takes username(string) and problem_id(integer)
  #returns void
  def self.assign(username, problem_id)
    current_problem = Problem.find(problem_id.to_i)

    current_problem.update(assigned_to: username,
                           status: "assigned")
  end

  #change problem status
  #takes problem_id(integer) and stauts(string)
  #returns void
  def self.change_status(problem_id, status)
    current_problem = Problem.where(id: problem_id)

    current_problem.update(status: status)
  end

  #solve a problem
  #takes username(string) and problem_id(integer)
  #returns void
  def self.solve(username, problem_id, current_time)
    current_problem = Problem.find(problem_id.to_i)

    current_problem.update(solved_by: username,
                           solved_on: current_time,
                           status: "solved"
                           )
    
  end

  #check if problem is assigned to anybody
  #takes problem id(integer)
  #returns true or false
  def self.is_assigned(problem_id)
    current_problem = Problem.where(id: problem_id).first

    if current_problem.status == "assigned"
      return true
    else
      return false
    end
  end

  #get username of the person a problem is assigned to
  def self.assigned_to(problem_id)
    assigned_to = Problem.find(problem_id.to_i).assigned_to

    return assigned_to
  end

end
