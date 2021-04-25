# == Schema Information
#
# Table name: feedback_dates
#
#  id             :bigint           not null, primary key
#  end_date       :datetime
#  start_date     :datetime
#  tmr_status     :string           default("in_progress")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  list_module_id :bigint
#
# Indexes
#
#  index_feedback_dates_on_list_module_id  (list_module_id)
#
# Foreign Keys
#
#  fk_rails_...  (list_module_id => list_modules.id)
#
class FeedbackDate < ApplicationRecord
  belongs_to :list_module
  has_many :tmr_signatures, dependent: :destroy

  #one team meeting record per feedback date window
  has_one_attached :tmr

  #many peer feedbacks per feedback date window
  has_many :peer_feedbacks, dependent: :destroy

  def self.get_closest_date(current_date, module_id)
    closest_date = nil

    feedback_dates = FeedbackDate.where(list_module_id: module_id).order(:start_date)
    
    for i in 0...feedback_dates.length
      start_diff = feedback_dates[i].start_date - current_date
      end_diff = feedback_dates[i].end_date - current_date

      if start_diff <= 0 && end_diff > 0 && closest_date.nil?
        closest_date = feedback_dates[i]
        break
      end

    end

    if closest_date.nil?
      for i in 0...feedback_dates.length
        start_diff = feedback_dates[i].start_date - current_date
        end_diff = feedback_dates[i].end_date - current_date
        
        if start_diff > 0 && end_diff > 0
          closest_date = feedback_dates[i]
          break
        end
      end
    end

    return closest_date
  end

  def self.is_in_feedback_window(current_date, module_id)
    feedback_dates = FeedbackDate.where(list_module_id: module_id).order(:start_date)
    result = false
    for i in 0...feedback_dates.length
      start_diff = feedback_dates[i].start_date - current_date
      end_diff = feedback_dates[i].end_date - current_date

      if start_diff <= 0 && end_diff > 0
        result = true
        break
      end

    end

    return result
  end

  def self.check_tmr_completion(team_id, feedback_date_id)
    num_of_signs_needed = Team.get_current_team_size(team_id)
    puts "-------------------------------"
    puts num_of_signs_needed
    puts TmrSignature.get_tmr_signatures(feedback_date_id).length
    puts "-------------------------------"

     if TmrSignature.get_tmr_signatures(feedback_date_id).length == num_of_signs_needed
      return true
     else
      return false
     end
  end

  def self.unsign_tmr(feedback_date_id)
    TmrSignature.where(feedback_date_id: feedback_date_id).destroy_all
  end
end
