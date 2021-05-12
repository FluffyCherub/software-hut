# == Schema Information
#
# Table name: tmrs
#
#  id         :bigint           not null, primary key
#  status     :string           default("in_progress")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_tmrs_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class Tmr < ApplicationRecord
  #connnecting to other databse tables
  belongs_to :team
  has_many :tmr_signatures, dependent: :destroy

  #each team meeting record gas one pdf document attached
  has_one_attached :tmr_doc, dependent: :destroy


  #get a team meeting record which is not finished for a team
  #takes team id(integer)
  #returns Tmr object
  def self.get_unfinished_tmr(team_id)
    result = Tmr.where("tmrs.team_id = ? AND
                       (tmrs.status = ? OR tmrs.status = ?)",
                       team_id,
                       "in_progress",
                       "submitted")

    
    if result.length == 0
      return nil
    else
      return result.first
    end
  end

  #adding a team meeting record for a team
  #takes team_id(integer) and a team meeting record pdf(pdf file)
  #returns void
  def self.add_tmr(team_id, tmr_pdf)
    new_tmr = Tmr.create(status: "submitted",
                         team_id: team_id)
    new_tmr.tmr_doc.attach(tmr_pdf)
  end

  #check if a team meeting record is signed by every team member
  #takes team meeting record id(integer) and team_id(integer)
  #returns true or false
  def self.check_tmr_completion(tmr_id, team_id)
    num_of_signs_needed = Team.get_current_team_size(team_id)
    
     if TmrSignature.get_tmr_signatures(tmr_id).length == num_of_signs_needed
      return true
     else
      return false
     end
  end

  def self.get_all_tmr_for_team(team_id)
    tmrs = Tmr.where(team_id: team_id,
                     status: "finished")

    return tmrs
  end
end
