class CreateFeedbackDates < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_dates do |t|
      t.datetime :start_date
      t.datetime :end_date

      t.belongs_to :list_module, index: true, foreign_key: true

      t.timestamps
    end
  end
end
