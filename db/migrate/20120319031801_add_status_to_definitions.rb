class AddStatusToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :status, :string, :default => 'raw'
  end
end
