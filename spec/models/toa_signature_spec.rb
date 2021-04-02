# == Schema Information
#
# Table name: toa_signatures
#
#  id                          :bigint           not null, primary key
#  date                        :string           default("")
#  name                        :string           default("")
#  signature                   :string           default("")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  team_operating_agreement_id :bigint
#
# Indexes
#
#  index_toa_signatures_on_team_operating_agreement_id  (team_operating_agreement_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_operating_agreement_id => team_operating_agreements.id)
#
require 'rails_helper'

RSpec.describe ToaSignature, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
