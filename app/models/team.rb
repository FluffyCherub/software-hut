# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
#  topic          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  list_module_id :bigint           not null
#
# Indexes
#
#  index_teams_on_list_module_id  (list_module_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_module_id => list_modules.id)
#
class Team < ApplicationRecord
  belongs_to :list_module

  has_many :user_teams
  has_many :users, through: :user_teams
end
