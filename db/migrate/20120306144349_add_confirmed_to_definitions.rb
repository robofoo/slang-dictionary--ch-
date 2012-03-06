class AddConfirmedToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :confirmed, :boolean, :default => false

  end
end
