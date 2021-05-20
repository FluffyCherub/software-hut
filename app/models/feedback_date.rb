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
class FeedbackDate < ApplicationRecord
  belongs_to :list_module

  #many peer feedbacks per feedback date window
  has_many :peer_feedbacks, dependent: :destroy

  has_many :team_feedback_dates, dependent: :destroy
  has_many :teams, through: :team_feedback_dates

  #get wither the current feedback period or the closest one in the future
  #takes current date and module id, returns a datetime object
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

  #checks if current date is in a feedback window
  #takes the current date and module id, returns true or false
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

  #get the most frequent feedback period which is in the past
  # takes the current date and module id, returns a ffedback period object
  def self.get_last_finished_period(current_date, module_id)

    all_periods = FeedbackDate.where(list_module_id: module_id)

    last_finished_period = nil

    #loop through  the periods
    for i in 0...all_periods.length
      if last_finished_period.nil? && all_periods[i].end_date - current_date < 0
        last_finished_period = all_periods[i]
      end 

      #check if date is in the past
      if all_periods[i].end_date - current_date < 0
        if all_periods[i].end_date - current_date > last_finished_period.end_date - current_date
          last_finished_period = all_periods[i]
        end
      end
    end 

    return last_finished_period
  end

  def self.get_period_number(feedback_date_id)
    period_number = 0

    #get a team connected to this feedback date
    team = Team.joins(:feedback_dates).where("feedback_dates.id = ?", feedback_date_id).first

    if team.nil?
      return nil
    end

    #get all feedback dates connected to this team
    f_dates = FeedbackDate.joins(:teams).where("teams.id = ?", team.id).order("end_date DESC")

    for i in 0...f_dates.length
      
      if f_dates[i].id = feedback_date_id
        period_number = i+1
      end

    end

    return period_number
  end

  def self.get_all_connected_students(feedback_date_id)

    #get all teams connected to the feedback date
    teams = Team.joins(:feedback_dates).where("feedback_dates.id = ?", feedback_date_id).group(:id).pluck(:id)

    users = User.joins(:teams).where("teams.id IN (?)", teams).group(:id)

    return users
  end
  
end
