# == Schema Information
#
# Table name: problem_notes
#
#  id         :bigint           not null, primary key
#  created_by :string
#  note       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  problem_id :bigint
#
# Indexes
#
#  index_problem_notes_on_problem_id  (problem_id)
#
# Foreign Keys
#
#  fk_rails_...  (problem_id => problems.id)
#
class ProblemNote < ApplicationRecord
  belongs_to :problem

  #get notes for a problem
  #takes problem_id(integer)
  #returns ProblemNote object
  def self.get_notes_for_problem(problem_id)
    notes = ProblemNote.where(problem_id: problem_id)

    return notes
  end
end
