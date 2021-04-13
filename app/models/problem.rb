# == Schema Information
#
# Table name: problems
#
#  id          :bigint           not null, primary key
#  assigned_to :string
#  created_by  :string
#  note        :string
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

end
