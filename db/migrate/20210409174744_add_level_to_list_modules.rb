class AddLevelToListModules < ActiveRecord::Migration[6.0]
  def change
    add_column :list_modules, :level, :integer
  end
end
