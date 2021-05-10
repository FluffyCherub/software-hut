# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
#  status         :string           default("waiting_for_approval")
#  toa_status     :string           default("in_progress")
#  topic          :string           default("none")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  list_module_id :bigint
#
# Indexes
#
#  index_teams_on_list_module_id  (list_module_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_module_id => list_modules.id)
#
FactoryBot.define do
  factory :team do
    name { "MyString" }
    topic { "MyString" }
    size { "" }
    list_module { nil }
    created_at {DateTime.now()}
    updated_at {DateTime.now()}
  end
end
