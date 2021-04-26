class RemoveFeedbackDateReferencesFromTmrSignatures < ActiveRecord::Migration[6.0]
  def change
    change_table :tmr_signatures do |t|
      t.remove_references :feedback_date
    end
  end
end
