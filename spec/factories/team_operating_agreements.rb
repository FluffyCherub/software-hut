# == Schema Information
#
# Table name: team_operating_agreements
#
#  id                  :bigint           not null, primary key
#  decision_making     :string           default("")
#  end_date            :string           default("")
#  last_edited         :datetime
#  last_opened         :datetime
#  meetings            :string           default("")
#  module_leader       :string           default("")
#  module_name         :string           default("")
#  personal_courtesies :string           default("")
#  project_name        :string           default("")
#  start_date          :string           default("")
#  status              :string           default("in_progress")
#  team_communications :string           default("")
#  team_mission        :string           default("")
#  team_name           :string           default("")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  team_id             :bigint
#
# Indexes
#
#  index_team_operating_agreements_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
FactoryBot.define do
  factory :team_operating_agreement do
    
  end
end
