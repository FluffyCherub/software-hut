class AddMailMessageToListModules < ActiveRecord::Migration[6.0]
  def change
    add_column :list_modules, :mailmerge_message, :string, default: ''
  end
end
