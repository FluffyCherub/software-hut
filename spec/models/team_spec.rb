# == Schema Information
#
# Table name: teams
#
#  id             :bigint           not null, primary key
#  name           :string
#  size           :integer
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
require 'rails_helper'

describe Team do
  before :all do
    @user1 = FactoryBot.create :user, id: 1, username: 'abc12ef'
    @user2 = FactoryBot.create :user, id: 2, username: 'def34gh'
    @user3 = FactoryBot.create :user, id: 3, username: 'ghi56ij'
    @user4 = FactoryBot.create :user, id: 4, username: 'jkl78mn'
    @user5 = FactoryBot.create :user, id: 5, username: 'mno90pq'

    @listmodule1 = FactoryBot.create :list_module, id: 1

    @usermodule1 = FactoryBot.create :user_list_module, id: 1, privilege: 'student',
    list_module_id: 1, user_id: 1
    @usermodule2 = FactoryBot.create :user_list_module, id: 2, privilege: 'student',
    list_module_id: 1, user_id: 2
    @usermodule3 = FactoryBot.create :user_list_module, id: 3, privilege: 'student',
    list_module_id: 1, user_id: 3
    @usermodule4 = FactoryBot.create :user_list_module, id: 4, privilege: 'teaching_assistant',
    list_module_id: 1, user_id: 4
    @usermodule5 = FactoryBot.create :user_list_module, id: 5, privilege: 'student',
    list_module_id: 1, user_id: 4
  end

  describe
end
