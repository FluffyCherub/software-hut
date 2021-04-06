# == Schema Information
#
# Table name: list_modules
#
#  id          :bigint           not null, primary key
#  code        :string
#  created_by  :string
#  description :string
#  name        :string
#  semester    :string
#  years       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ListModule < ApplicationRecord
  validates :name , presence: true
  validates :code , presence: true
  validates :description , presence: true
  validates :semester , presence: true
  validates :years , presence: true
  validates :created_by , presence: true


  has_many :user_list_modules
  has_many :users, through: :user_list_modules
  has_many :teams
end
