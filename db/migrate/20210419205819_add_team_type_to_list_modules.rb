class AddTeamTypeToListModules < ActiveRecord::Migration[6.0]
  def change
    add_column :list_modules, :team_type, :string, default: 'random'
  end
end
