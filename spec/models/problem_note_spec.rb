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
require 'rails_helper'

RSpec.describe ProblemNote, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
