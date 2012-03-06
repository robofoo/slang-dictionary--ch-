class AddReviewedToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :reviewed, :boolean, :default => false

  end
end
