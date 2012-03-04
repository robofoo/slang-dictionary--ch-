class AddCodeToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :code, :string

  end
end
