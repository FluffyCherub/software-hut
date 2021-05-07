class AddStatusToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :status, :string, default: 'waiting_for_approval'
  end
end
