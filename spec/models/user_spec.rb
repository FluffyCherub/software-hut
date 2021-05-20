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
    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc321', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'David', sn: 'Tim', username: 'dtim13gh', email: 'asdd.ac.uk')
    
    @user4 = create(:user,username: 'asd223', email: 'j231@sheffield.ac.uk')
    @user5 = create(:user, username: 'ccc333', email: 'asccdd@sheffield.ac.uk')
    @admin_user = create(:user, username: 'adminute', email: 'admin222@sheffield.ac.uk', admin: true)
    @suspended_user = create(:user, username: 'ssus', email: 'ssus@sheffield.ac.uk', suspended: true)
    @suspended_admin_user = create(:user, username: 'susadmin', email: 'susadmin@sheffield.ac.uk', suspended: true, admin: true)

    @listmodule = create(:list_module, code: 'COM101', name: 'Intro to Java',
       level: 1, created_at: DateTime.now(), updated_at: DateTime.now())
    @usermodule = create(:user_list_module, privilege: 'student', created_at: DateTime.now(), updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user.id)
    @usermodule2 = create(:user_list_module, privilege: 'module_leader', created_at: DateTime.now(), updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user4.id)
    @usermodule3 = create(:user_list_module, privilege: 'teaching_assistant_5', created_at: DateTime.now(), updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user5.id)
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
    it 'return 0 if the email is valid' do
      expect(User.check_if_email(@user.email)).to eq 0
    end
    it 'return 1 if the email is invalid' do
      expect(User.check_if_email(@user3.email)).to eq nil
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
      expect(User.get_user_id(@user.username)).to eq @user.id
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
  
  describe '#is_ta_or_mod_lead' do
    it 'returns true if the user is module leader' do
      expect(User.is_ta_or_mod_lead(@user4.username)).to eq true
    end
    it 'returns true if the user is teaching assistance' do
      expect(User.is_ta_or_mod_lead(@user5.username)).to eq true
    end
    it 'returns false if the user is not any of them' do
      # I think there is an error in the code where it didn't check if it is the role of the user
      expect(User.is_ta_or_mod_lead(@user.username)).to eq false
    end
  end

  
  describe '#is_mod_lead' do
    it 'returns true if the user is module leader' do
      expect(User.is_mod_lead(@user4.username)).to eq true
    end
    it 'returns false if the user is teaching assistance' do
      # I think there is an error in the code where it didn't check if it is the role of the user
      expect(User.is_mod_lead(@user5.username)).to eq false
    end
    it 'returns false if the user is not any of them' do
      # I think there is an error in the code where it didn't check if it is the role of the user
      expect(User.is_mod_lead(@user.username)).to eq false
    end
  end

  describe '#is_ta' do
    it 'returns true if the user is teaching assistance' do
      expect(User.is_ta(@user5.username)).to eq true
    end
    it 'returns false if the user is module leader' do
      # I think there is an error in the code where it didn't check if it is the role of the user
      expect(User.is_ta(@user4.username)).to eq false
    end
    it 'returns false if the user is not any of them' do
      # I think there is an error in the code where it didn't check if it is the role of the user
      expect(User.is_ta(@user.username)).to eq false
    end
  end


  describe '#get_module_privilege' do
    it 'checks status of John Smith in module 101' do
      expect(User.get_module_privilege(@listmodule.id, @user.id)).to eq 'student'
    end
    it 'checks module privilege of a user who is not within the module' do
      # the user has a privilege of student instead
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
    it 'attempts to change privilege of a student who is not within the module' do
      User.change_privilege_user_module(@user2.username, @listmodule.id, 'student')
      # a user who is not within the module obtain a student privilege instead
      expect(User.get_module_privilege(@listmodule, @user2.id)).to eq nil
    end
  end

  
  describe '#highest_privilege' do
    it 'returns admin if the user is an admin' do
      expect(User.highest_privilege(@admin_user.id)).to eq 'admin'
    end
    it 'returns suspended if the user is suspended' do
      expect(User.highest_privilege(@suspended_user.id)).to eq 'suspended'
    end
    it 'returns suspended if the user has a role, but suspended' do
      expect(User.highest_privilege(@suspended_admin_user.id)).to eq 'suspended'
    end
    it 'returns student if the user is only a student' do
      expect(User.highest_privilege(@user.id)).to eq 'student'
    end
    it 'returns module leader if the user is a module leader in any module' do
      expect(User.highest_privilege(@user4.id)).to eq 'module_leader'
    end
    it 'returns teaching assistance if the user is a teaching assistance in any module' do
      expect(User.highest_privilege(@user5.id)).to eq 'teaching_assistant'
    end
  end

  describe '#is_student_in_any_module' do
    it 'returns true if the user is in a module as a student' do
      expect(User.is_student_in_any_module(@user.id)).to eq true
    end
    it 'returns false if the user is not in a module' do
      expect(User.is_student_in_any_module(@user2.id)).to eq false
    end
    it 'returns false if the user is in a module, but not as a student' do
      expect(User.is_student_in_any_module(@user4.id)).to eq  false
    end
    
  end
end

