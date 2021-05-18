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

  
  before :all do
    
    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @user4 = create(:user, givenname: 'Wendy', sn: 'Boby', username: '123561', email: 'wboby2@sheffield.ac.uk')
    @listmodule = create(:list_module)
    
    #create teams
    @team1 = create(:team, size: 3, list_module_id: @listmodule.id)

    @problem1 = create(:problem, team_id: @team1.id)
    @problem2 = create(:problem, team_id: @team1.id)

    @problem_note = create(:problem_note, problem_id: @problem1.id)
    @problem_note2 = create(:problem_note, problem_id: @problem1.id)

  end
  
  describe '#get_notes_for_problem' do
    it 'return the problem note in the problem' do
      expect(ProblemNote.get_notes_for_problem(@problem1.id)).to include(@problem_note, @problem_note2)
    end
    it 'return empty if there is problem not exist' do
      expect(ProblemNote.get_notes_for_problem(6542412)).to eq []
    end
    it 'return empty if there is problem notes not exist' do
      expect(ProblemNote.get_notes_for_problem(@problem2.id)).to eq []
    end
  end
end
