# == Schema Information
#
# Table name: user_list_modules
#
#  id             :bigint           not null, primary key
#  privilege      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  list_module_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_user_list_modules_on_list_module_id  (list_module_id)
#  index_user_list_modules_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_module_id => list_modules.id)
#  fk_rails_...  (user_id => users.id)
#
class UserListModule < ApplicationRecord
  #connection to other database tables
  belongs_to :list_module
  belongs_to :user
end
