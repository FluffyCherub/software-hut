class CreateTeamFeedbackDates < ActiveRecord::Migration[6.0]
  def change
    create_table :team_feedback_dates do |t|
      t.references :team, null: false, foreign_key: true
      t.references :feedback_date, null: false, foreign_key: true

      t.timestamps
    end
  end
end
