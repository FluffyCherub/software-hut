class CreateProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.string :created_by
      t.string :status, default: 'unsolved'
      t.string :assigned_to
      t.string :note

      t.belongs_to :team, index: true, foreign_key: true

      t.timestamps
    end
  end
end
