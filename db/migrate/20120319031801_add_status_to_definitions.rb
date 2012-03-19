class AddStatusToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :status, :string, :default => 'new'
  end
end
