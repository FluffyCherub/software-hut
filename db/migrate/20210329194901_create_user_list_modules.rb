class CreateUserListModules < ActiveRecord::Migration[6.0]
  def change
    create_table :user_list_modules do |t|
      t.references :list_module, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.string :privilege

      t.timestamps
    end
  end
end
