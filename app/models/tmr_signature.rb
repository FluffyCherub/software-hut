# == Schema Information
#
# Table name: tmr_signatures
#
#  id               :bigint           not null, primary key
#  signed_at        :datetime
#  signed_by        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  feedback_date_id :bigint
#
# Indexes
#
#  index_tmr_signatures_on_feedback_date_id  (feedback_date_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_date_id => feedback_dates.id)
#
class TmrSignature < ApplicationRecord
  belongs_to :feedback_date

  def self.check_signature(username, feedback_date_id)
    signature_check = TmrSignature.where(feedback_date_id: feedback_date_id,
                                         signed_by: username)

    if signature_check.length == 0
      return false
    else
      return true
    end
  end

  def self.get_tmr_signatures(feedback_date_id)
    signs = TmrSignature.where(feedback_date_id: feedback_date_id)

    return signs
  end

end
