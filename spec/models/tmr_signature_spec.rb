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
require 'rails_helper'

RSpec.describe TmrSignature, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
