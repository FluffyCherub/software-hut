# == Schema Information
#
# Table name: feedback_dates
#
#  id             :bigint           not null, primary key
#  end_date       :datetime
#  start_date     :datetime
#  tmr_status     :string           default("in_progress")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  list_module_id :bigint
#
# Indexes
#
#  index_feedback_dates_on_list_module_id  (list_module_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_module_id => list_modules.id)
#
FactoryBot.define do
  factory :feedback_date do
    start_date { "2021-04-20 02:09:48" }
    end_date { "2021-04-20 02:09:48" }
  end
end
