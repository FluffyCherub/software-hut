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
    @feedback_date1 = FactoryBot.create :feedback_date, start_date: Time.new(2021, 5, 8),
    end_date: Time.new(2021, 6, 8), list_module_id: @listmodule.id
    @feedback_date2 = FactoryBot.create :feedback_date, start_date: Time.new(2021, 7, 8),
    end_date: Time.new(2021, 9, 8), list_module_id: @listmodule.id

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
end
