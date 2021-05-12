class AddReminderSentToFeedbackDate < ActiveRecord::Migration[6.0]
  def change
    add_column :feedback_dates, :reminder_sent, :boolean, default: false
  end
end
