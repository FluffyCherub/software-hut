class DropToaSignaturesTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :toa_signatures
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
