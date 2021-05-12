class AddPeriodOpenSentToFeedbackDates < ActiveRecord::Migration[6.0]
  def change
    add_column :feedback_dates, :period_open_sent, :boolean, default: false
  end
end
