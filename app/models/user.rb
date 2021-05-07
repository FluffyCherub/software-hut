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
  #connection to other database tables
  has_many :user_list_modules
  has_many :list_modules, through: :user_list_modules
  has_many :user_teams
  has_many :teams, through: :user_teams

  #get user object for a user
  #takes user id(integer)
  #returns User object
  def self.get_user_info_by_id(user_id)
    user_info = User.where(id: user_id).first
    return user_info
  end

  #regex to check if stirng is an email
  #takes emiail(string)
  #returns true or false
  def self.check_if_email(email)
    email =~ /\S+@\S+\.\S+/
  end

  #get module privilege for a user
  #takes module id(integer) and user id(integer)
  #returns privilege(string)
  def self.get_module_privilege(module_id, user_id)
    privilege = UserListModule.where(list_module_id: module_id,
                                     user_id: user_id).first

    if privilege != nil
      return privilege.privilege
    else
      return privilege
    end
  end

  #check if user exists in the system
  #takes username(string)
  #returns true or false
  def self.is_user_in_system(username)
    check_user = User.where(username: username)

    if check_user.length == 0
      return false
    else
      return true
    end
  end

  #check if user is linked to a module
  #takes username(string) and module id(integer)
  #returns true or false
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

  #change module privilege for a user
  #takes username(string) and module id(integer) and privilege(string)
  #returns void
  def self.change_privilege_user_module(username, module_id, privilege)
    user_list_module = UserListModule.joins(:user).where("users.username = ? AND
                                                          user_list_modules.list_module_id = ?",
                                                          username,
                                                          module_id)

    user_list_module.update(privilege: privilege)
  end

  #get id of a user
  #takes username(string)
  #returns user id(integer)
  def self.get_user_id(username)
    user_id = User.where(username: username).first.id
    return user_id
  end

  #get first and last name of a user
  #takes username(string)
  #returns first name + last name(string)
  def self.get_first_last(username)
    user = User.where(username: username).first

    return user.givenname + " " + user.sn
  end

  #get email of a user
  #takes username(string)
  #returns email(string)
  def self.get_email(username)
    user = User.where(username: username).first

    return user.email
  end
end
