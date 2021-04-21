class CreateTmrSignatures < ActiveRecord::Migration[6.0]
  def change
    create_table :tmr_signatures do |t|
      t.string :signed_by
      t.datetime :signed_at

      t.belongs_to :feedback_date, index: true, foreign_key: true

      t.timestamps
    end
  end
end
