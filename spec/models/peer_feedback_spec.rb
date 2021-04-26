# == Schema Information
#
# Table name: peer_feedbacks
#
#  id               :bigint           not null, primary key
#  appreciate       :string           default("")
#  attendance       :integer
#  attitude         :integer
#  collaboration    :integer
#  communication    :integer
#  created_by       :string
#  created_for      :string
#  ethics           :integer
#  leadership       :integer
#  qac              :integer
#  request          :string           default("")
#  status           :string           default("in_progress")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  feedback_date_id :bigint
#
# Indexes
#
#  index_peer_feedbacks_on_feedback_date_id  (feedback_date_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_date_id => feedback_dates.id)
#
require 'rails_helper'

RSpec.describe PeerFeedback, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
