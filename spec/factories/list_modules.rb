# == Schema Information
#
# Table name: list_modules
#
#  id                :bigint           not null, primary key
#  code              :string
#  created_by        :string
#  description       :string
#  level             :integer
#  mailmerge_message :string           default("")
#  name              :string
#  semester          :string
#  team_type         :string           default("random")
#  years             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'date'

FactoryBot.define do
  factory :list_module do
    name { "couse_name" }
    code { "course_code" }
    description { "description" }
    level { 1 }
    semester { "SPRING" }
    created_by {"some_user"}
    years {"2021/2022"}
    created_at { DateTime.now() }
    updated_at { DateTime.now() }
  end
end
