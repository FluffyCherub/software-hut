class CreateTmrs < ActiveRecord::Migration[6.0]
  def change
    create_table :tmrs do |t|
      t.string :status, default: 'in_progress'

      t.belongs_to :team, index: true, foreign_key: true

      t.timestamps
    end
  end
end
