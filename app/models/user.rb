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
class User < ApplicationRecord
  require 'csv'
  include EpiCas::DeviseHelper
  has_many :user_list_modules
  has_many :list_modules, through: :user_list_modules  

  has_many :user_teams
  has_many :teams, through: :user_teams

  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  def self.get_user_info_by_id(user_id)
    user_info = User.where(id: user_id).first
    return user_info
  end

  def self.check_if_email(email)
    email =~ /\S+@\S+\.\S+/
  end

  def self.get_module_privilege(module_id, user_id)
    privilege = UserListModule.where(list_module_id: module_id,
                                     user_id: user_id).first

    if privilege != nil
      return privilege.privilege
    else
      return privilege
    end
  end

  def self.is_user_in_system(username)
    check_user = User.where(username: username)

    if check_user.length == 0
      return false
    else 
      return true
    end
  end

  def self.is_user_in_module(username, module_id)
    check_user_module = UserListModule.joins(:user).where("user_list_modules.list_module_id = ? AND
                                                           users.username = ?",
                                                           module_id,
                                                           username)

    if check_user_module.length == 0
      return false
    else 
      return true
    end
  end

  def self.change_privilege_user_module(username, module_id, privilege)
    user_list_module = UserListModule.joins(:user).where("users.username = ? AND
                                                          user_list_modules.list_module_id = ?",
                                                          username,
                                                          module_id)

    user_list_module.update(privilege: privilege)
  end

  def self.get_user_id(username)
    user_id = User.where(username: username).first.id
    return user_id
  end

  def self.get_first_last(username)
    user = User.where(username: username).first

    return user.givenname + " " + user.sn
  end

  def self.get_email(username)
    user = User.where(username: username).first

    return user.email
  end
end
