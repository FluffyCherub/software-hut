# == Schema Information
#
# Table name: tmrs
#
#  id         :bigint           not null, primary key
#  status     :string           default("in_progress")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint
#
# Indexes
#
#  index_tmrs_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

RSpec.describe Tmr, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
