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
  belongs_to :team

  has_many :tmr_signatures, dependent: :destroy

  has_one_attached :tmr_doc, dependent: :destroy

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

  def self.add_tmr(team_id, tmr_pdf)
    new_tmr = Tmr.create(status: "submitted",
                         team_id: team_id)
    new_tmr.tmr_doc.attach(tmr_pdf)
  end

  def self.check_tmr_completion(tmr_id, team_id)
    num_of_signs_needed = Team.get_current_team_size(team_id)
    
     if TmrSignature.get_tmr_signatures(tmr_id).length == num_of_signs_needed
      return true
     else
      return false
     end
  end
end
