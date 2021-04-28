class AddApprovedStatusToFeedbackDates < ActiveRecord::Migration[6.0]
  def change
    add_column :feedback_dates, :feedback_status, :string, default: 'not_approved'
  end
end
