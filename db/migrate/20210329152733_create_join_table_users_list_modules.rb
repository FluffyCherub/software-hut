class CreateJoinTableUsersListModules < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :list_modules do |t|
      t.index [:user_id, :list_module_id]
      t.index [:list_module_id, :user_id]

      t.string :privilege
    end
  end
end
