class AddTmrToTmrSignatures < ActiveRecord::Migration[6.0]
  def change
    add_reference :tmr_signatures, :tmr, null: false, foreign_key: true
  end
end
