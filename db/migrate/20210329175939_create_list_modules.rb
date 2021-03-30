class CreateListModules < ActiveRecord::Migration[6.0]
  def change
    create_table :list_modules do |t|
      t.string :name
      t.string :code
      t.string :description
      t.string :created_by
      t.string :semester
      t.string :years

      t.timestamps
    end
  end
end
