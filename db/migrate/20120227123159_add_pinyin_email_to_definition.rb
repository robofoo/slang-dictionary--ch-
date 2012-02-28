class AddPinyinEmailToDefinition < ActiveRecord::Migration
  def change
    add_column :definitions, :pinyin, :string

    add_column :definitions, :email, :string

  end
end
