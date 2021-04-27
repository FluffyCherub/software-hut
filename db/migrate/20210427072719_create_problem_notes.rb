class CreateProblemNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :problem_notes do |t|
      t.string :created_by
      t.string :note

      t.belongs_to :problem, index: true, foreign_key: true

      t.timestamps
    end
  end
end
