# == Schema Information
#
# Table name: tmr_signatures
#
#  id         :bigint           not null, primary key
#  signed_at  :datetime
#  signed_by  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tmr_id     :bigint           not null
#
# Indexes
#
#  index_tmr_signatures_on_tmr_id  (tmr_id)
#
# Foreign Keys
#
#  fk_rails_...  (tmr_id => tmrs.id)
#
class TmrSignature < ApplicationRecord
  belongs_to :tmr

  #check if a user signed a team meeting record
  #takes username(string) and team meeting record id(integer)
  def self.check_signature(username, tmr_id)
    signature_check = TmrSignature.where(tmr_id: tmr_id,
                                         signed_by: username)

    if signature_check.length == 0
      return false
    else
      return true
    end
  end

  #get a list of team meeting record signatures for a team meeting record
  #takes team meeting record id(integer)
  #returns an array of TmrSignature objects
  def self.get_tmr_signatures(tmr_id)
    signs = TmrSignature.where(tmr_id: tmr_id)

    return signs
  end

end
