# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  admin                :boolean          default(FALSE)
#  confirmation_sent_at :datetime
#  confirmation_token   :string
#  confirmed_at         :datetime
#  current_sign_in_at   :datetime
#  current_sign_in_ip   :inet
#  dn                   :string
#  email                :string           default(""), not null
#  failed_attempts      :integer          default(0), not null
#  givenname            :string
#  last_sign_in_at      :datetime
#  last_sign_in_ip      :inet
#  locked_at            :datetime
#  mail                 :string
#  ou                   :string
#  sign_in_count        :integer          default(0), not null
#  sn                   :string
#  suspended            :boolean          default(FALSE)
#  uid                  :string
#  unconfirmed_email    :string
#  unlock_token         :string
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email)
#  index_users_on_username  (username)
#
require 'rails_helper'

RSpec.describe User, type: :model do

  before :all do
    @user = create(:user, id: 123, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, id: 2, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @listmodule = create(:list_module, id: 101, code: 'COM101', name: 'Intro to Java',
       level: 1, created_at: DateTime.now(), updated_at: DateTime.now())
    @usermodule = create(:user_list_module, id: 321, privilege: 'student', created_at: DateTime.now(), updated_at: DateTime.now(), list_module_id: 101, user_id: 123)
  end
  describe '#get_user_info_by_id' do

    it 'returns user info of real user' do
      expect(User.get_user_info_by_id(@user.id)).to eq @user
    end

    it 'returns user info of fake user' do
      expect(User.get_user_info_by_id(123124)).to eq nil
    end
  end

  describe '#check_if_email' do
    it 'checks if email is valid' do
      expect(User.check_if_email(@user.email)).to eq 0
    end
  end

  describe '#is_user_in_system' do
    it 'checks if real user is in system' do
      expect(User.is_user_in_system(@user.username)).to eq true
    end

    it 'checks if fake user is in system' do
      expect(User.is_user_in_system(123124)).to eq false
    end
  end

  describe '#get_user_id' do
    it 'returns id of a user from username' do
      expect(User.get_user_id(@user.username)).to eq 123
    end
  end

  describe '#get_first_last' do
    it 'returns first and lastname of user' do
      expect(User.get_first_last(@user.username)).to eq 'John Smith'
    end
  end

  describe '#get_email' do
    it 'returns user email' do
      expect(User.get_email(@user.username)).to eq 'jsmith1@sheffield.ac.uk'
    end
  end

  describe '#get_module_privilege' do
    it 'checks status of John Smith in module 101' do
      expect(User.get_module_privilege(@listmodule.id, @user.id)).to eq 'student'
    end
    it 'checks status of Jean Doe in module 101' do
      expect(User.get_module_privilege(@listmodule.id, @user2.id)).to eq nil
    end
  end

  describe '#is_user_in_module' do
    it 'checks if John Smith is in module 101' do
      expect(User.is_user_in_module(@user.username, @listmodule.id)).to eq true
    end
    it 'checks if Jean Doe is in module 101' do
      expect(User.is_user_in_module(@user2.username, @listmodule.id)).to eq false
    end
  end

  describe '#change_privilege_user_module' do
    it 'changes John Smith from student to teaching assistant' do
      User.change_privilege_user_module(@user.username, @listmodule.id, 'teaching assistant')
      expect(User.get_module_privilege(@listmodule.id, @user.id)).to eq 'teaching assistant'
    end
    it 'attempts to change priviledge of Jean Doe' do
      User.change_privilege_user_module(@user2.username, @listmodule.id, 'student')
      expect(User.get_module_privilege(@listmodule, @user2.id)).to eq nil
    end
  end
end

#RSpec.describe User, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"
#end
