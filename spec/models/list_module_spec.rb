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
require 'rails_helper'
require 'date'

describe ListModule do

  before :all do
    @user = create(:user, givenname: 'John', sn: 'Smith', username: 'abc12ef', email: 'jsmith1@sheffield.ac.uk')
    @user2 = create(:user, givenname: 'Jean', sn: 'Doe', username: 'xyz13gh', email: 'jdoe1@sheffield.ac.uk')
    @user3 = create(:user, givenname: 'Andy', sn: 'Brock', username: 'efg14ij', email: 'abrock1@sheffield.ac.uk')
    @listmodule = create(:list_module, code: 'COM101', name: 'Intro to Java',
       level: 1, created_at: DateTime.now(), updated_at: DateTime.now())
    @usermodule = create(:user_list_module, privilege: 'student', created_at: DateTime.now(), \
      updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user.id)
    @usermodule2 = create(:user_list_module, privilege: 'teaching_assistant', created_at: DateTime.now(), \
      updated_at: DateTime.now(), list_module_id: @listmodule.id, user_id: @user2.id)
  end

  describe '#generate_years' do
    it 'generate academic years based on current year' do
      expect(ListModule.generate_years(2021, 3)).to include("2021/2022", "2022/2023", "2023/2024")
    end
  end

  describe '#users_in_module' do
    it 'returns Users in module 101' do
      expect(ListModule.users_in_module(@listmodule.id).to_a).to include(@user, @user2)
    end
  end

  describe '#students_in_module' do
    it 'returns all students in module 101' do
      expect(ListModule.students_in_module(@listmodule.id).first).to eq @user
    end
  end

  describe '#privilege_for_module' do
    it 'returns privilege of Jean Doe in module 101' do
      expect(ListModule.privilege_for_module(@user2.username, @listmodule.id)).to eq 'teaching_assistant'
    end
    it 'returns privilege of a student who is not within the module' do
      # the function did not run
      expect(ListModule.privilege_for_module(@user3.username, @listmodule.id)).to eq nil
    end
  end

  describe '#num_students_in_mod' do
    it 'returns number of students in module 101' do
      expect(ListModule.num_students_in_mod(@listmodule.id)).to eq 1
    end
  end

  describe '#set_team_type' do
    it 'sets the team type of self_select' do
      ListModule.set_team_type(@listmodule.id, 'self_select')
      expect(ListModule.where(id: @listmodule.id).first.team_type).to eq 'self_select'
    end
  end

  describe '#get_mod_name_from_id' do
    it 'returns module name for module 101' do
      expect(ListModule.get_mod_name_from_id(@listmodule.id)).to eq 'Intro to Java'
    end
  end

  #TODO verify CSV file upload

end
#RSpec.describe ListModule, type: :model do
#  pending "add some examples to (or delete) #{__FILE__}"
#end
