class AddVisibleToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :visible, :boolean, :default => false

  end
end
