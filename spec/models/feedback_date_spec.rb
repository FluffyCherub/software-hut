# == Schema Information
#
# Table name: feedback_dates
#
#  id               :bigint           not null, primary key
#  end_date         :datetime
#  feedback_status  :string           default("not_approved")
#  period_open_sent :boolean          default(FALSE)
#  reminder_sent    :boolean          default(FALSE)
#  start_date       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  list_module_id   :bigint
#
# Indexes
#
#  index_feedback_dates_on_list_module_id  (list_module_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_module_id => list_modules.id)
#
require 'rails_helper'

describe FeedbackDate do

  before :all do

    @listmodule = FactoryBot.create :list_module
    @listmodule2 = FactoryBot.create :list_module
    @listmodule3 = FactoryBot.create :list_module
    @feedback_date1 = FactoryBot.create :feedback_date, start_date: Time.new(2021, 5, 8),
    end_date: Time.new(2021, 6, 8), list_module_id: @listmodule.id
    @feedback_date2 = FactoryBot.create :feedback_date, start_date: Time.new(2021, 7, 8),
    end_date: Time.new(2021, 9, 8), list_module_id: @listmodule.id

    @feedback_date3 = FactoryBot.create :feedback_date, start_date: Time.new(2021, 7, 8),
    end_date: Time.new(2021, 9, 8), list_module_id: @listmodule2.id # a feedback date in a module that has no team


    @user1 = FactoryBot.create :user, username: 'abc12ef'
    @user2 = FactoryBot.create :user, username: 'def34gh'
    @user3 = FactoryBot.create :user, username: 'def34g2'
    
    #create teams
    @team1 = FactoryBot.create :team, size: 6, list_module_id: @listmodule.id
    @team2 = FactoryBot.create :team, size: 6, list_module_id: @listmodule.id

    @team1_feedback_date1 = FactoryBot.create :team_feedback_date, feedback_date_id: @feedback_date1.id, team_id: @team1.id
    @team1_feedback_date2 = FactoryBot.create :team_feedback_date, feedback_date_id: @feedback_date2.id, team_id: @team1.id
    @team1_feedback_date1 = FactoryBot.create :team_feedback_date, feedback_date_id: @feedback_date1.id, team_id: @team2.id
    @team1_feedback_date2 = FactoryBot.create :team_feedback_date, feedback_date_id: @feedback_date2.id, team_id: @team2.id


    #fill the team
    @userteam1 = FactoryBot.create :user_team, team_id: @team1.id, user_id: @user1.id
    @userteam2 = FactoryBot.create :user_team, team_id: @team1.id, user_id: @user2.id
    @userteam3 = FactoryBot.create :user_team, team_id: @team2.id, user_id: @user3.id
  end

  describe '#get_closest_date' do
    it 'finds closest feedback date when prior to feedback window 1' do
      expect(FeedbackDate.get_closest_date(Time.new(2021, 5, 6), @listmodule.id)).to eq @feedback_date1
    end
    it 'finds closest feedback date when just after window 1' do
      expect(FeedbackDate.get_closest_date(Time.new(2021, 6, 9), @listmodule.id)).to eq @feedback_date2
    end
    it 'finds closest feedback date when just prior to window 2' do
      expect(FeedbackDate.get_closest_date(Time.new(2021, 9, 7), @listmodule.id)).to eq @feedback_date2
    end
    it 'finds closest feedback window during window 1' do
      expect(FeedbackDate.get_closest_date(Time.new(2021, 5, 17), @listmodule.id)).to eq @feedback_date1
    end
    it 'finds closest feedback window after all have passed' do
      expect(FeedbackDate.get_closest_date(Time.new(2022, 1, 1), @listmodule.id)).to eq nil
    end
  end

  describe '#is_in_feedback_window' do
    it 'returns if in feedback window when in window 1' do
      expect(FeedbackDate.is_in_feedback_window(Time.new(2021, 5, 12), @listmodule.id)).to eq true
    end
    it 'returns if in feedback window when not in a window' do
      expect(FeedbackDate.is_in_feedback_window(Time.new(2021, 6, 20), @listmodule.id)).to eq false
    end
  end

  describe '#get_last_finished_period' do
    it 'returns last window before any window' do
      expect(FeedbackDate.get_last_finished_period(Time.new(2014, 1, 1), @listmodule.id)).to eq nil
    end
    it 'returns last window while between window 1 and 2' do
      expect(FeedbackDate.get_last_finished_period(Time.new(2021, 6, 20), @listmodule.id)).to eq @feedback_date1
    end
    it 'returns last window during window 2' do
      expect(FeedbackDate.get_last_finished_period(Time.new(2021, 7, 20), @listmodule.id)).to eq @feedback_date1
    end
    it 'returns last window after window 2' do
      expect(FeedbackDate.get_last_finished_period(Time.new(2021, 12, 23), @listmodule.id)).to eq @feedback_date2
    end
  end

  describe '#get_period_number' do
    it 'returns period number of the feedback date id' do
      expect(FeedbackDate.get_period_number(@feedback_date1.id)).to eq 2
    end
    
    it 'returns correct output when there is no team in the module' do
      expect(FeedbackDate.get_period_number(@feedback_date3.id)).to eq nil # or nil
    end
  end


  describe '#get_all_connected_students' do
    it 'returns the connected students of the feedback date id' do
      expect(FeedbackDate.get_all_connected_students(@feedback_date1.id)).to include(@user1, @user2, @user3)
    end
    
  end
end
