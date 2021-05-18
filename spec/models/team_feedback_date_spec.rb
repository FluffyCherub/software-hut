# == Schema Information
#
# Table name: team_feedback_dates
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  feedback_date_id :bigint           not null
#  team_id          :bigint           not null
#
# Indexes
#
#  index_team_feedback_dates_on_feedback_date_id  (feedback_date_id)
#  index_team_feedback_dates_on_team_id           (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_date_id => feedback_dates.id)
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

RSpec.describe TeamFeedbackDate, type: :model do

end
