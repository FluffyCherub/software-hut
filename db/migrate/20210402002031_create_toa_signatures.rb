class CreateToaSignatures < ActiveRecord::Migration[6.0]
  def change
    create_table :toa_signatures do |t|
      t.string :name, default: ''
      t.string :signature, default: ''
      t.string :date, default: ''

      t.belongs_to :team_operating_agreement, index: true, foreign_key: true
      
      t.timestamps
    end
  end
end
