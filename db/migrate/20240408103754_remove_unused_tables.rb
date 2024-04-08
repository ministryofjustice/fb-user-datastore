class RemoveUnusedTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :codes
    drop_table :emails
    drop_table :mobiles
    drop_table :magic_links
    drop_table :save_returns
  end
end
