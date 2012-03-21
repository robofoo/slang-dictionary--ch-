class AddScoreToDefinition < ActiveRecord::Migration
  def change
    add_column :definitions, :score, :integer, :default => 0
  end
end
