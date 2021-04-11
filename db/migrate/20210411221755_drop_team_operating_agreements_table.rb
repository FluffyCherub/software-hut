class DropTeamOperatingAgreementsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :team_operating_agreements
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
