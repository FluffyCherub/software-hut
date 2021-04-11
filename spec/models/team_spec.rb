# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
#  toa_status     :string           default("in_progress")
#  topic          :string
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
require 'rails_helper'

RSpec.describe Team, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
