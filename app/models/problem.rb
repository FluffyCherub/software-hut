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

  def self.get_problems_for_team(team_id)
    problems = Problem.where(team_id: team_id)

    return problems
  end

  def self.assign(username, problem_id)
    current_problem = Problem.where(id: problem_id)

    current_problem.update(assigned_to: username)
  end

  def self.change_status(problem_id, status)
    current_problem = Problem.where(id: problem_id)

    current_problem.update(status: status)
  end

  def self.solve(username, problem_id)
    current_problem = Problem.where(id: problem_id)

    current_problem.update(solved_by: username,
                           solved_on: Time.now,
                           )
  end

  def self.is_assigned(problem_id)
    current_problem = Problem.where(id: problem_id).first

    if current_problem.status == "assigned"
      return true
    else
      return false
    end
  end

end
