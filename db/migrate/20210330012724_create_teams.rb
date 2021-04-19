class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :topic, default: 'none'
      t.integer :size
      t.belongs_to :list_module, index: true, foreign_key: true

      t.timestamps
    end
  end
end
