# == Schema Information
#
# Table name: team_operating_agreements
#
#  id                  :bigint           not null, primary key
#  decision_making     :string
#  end_date            :string
#  last_edited         :datetime
#  last_opened         :datetime
#  meetings            :string
#  module_leader       :string
#  module_name         :string
#  personal_courtesies :string
#  project_name        :string
#  start_date          :string
#  team_communications :string
#  team_mission        :string
#  team_name           :string
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
require 'rails_helper'

RSpec.describe TeamOperatingAgreement, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
