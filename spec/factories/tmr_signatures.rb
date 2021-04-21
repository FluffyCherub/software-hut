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
FactoryBot.define do
  factory :tmr_signature do
    signed_by { "MyString" }
    signed_at { "2021-04-20 20:18:13" }
  end
end
