class RemoveVisibleAndConfirmedFromDefinitions < ActiveRecord::Migration
  def up
    remove_column :definitions, :visible
    remove_column :definitions, :confirmed
  end

  def down
    add_column :definitions, :visible, :boolean
    add_column :definitions, :confirmed, :boolean
  end
end
