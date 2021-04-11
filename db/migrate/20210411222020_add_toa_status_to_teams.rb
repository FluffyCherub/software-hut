class AddToaStatusToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :toa_status, :string, default: 'in_progress'
  end
end
