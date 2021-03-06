# == Schema Information
#
# Table name: user_teams
#
#  id               :bigint           not null, primary key
#  signed_agreement :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  team_id          :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_user_teams_on_team_id  (team_id)
#  index_user_teams_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :user_team do
    user { nil }
    team { nil }
    signed_agreement { false }
    created_at {DateTime.now()}
    updated_at {DateTime.now()}
  end
end
