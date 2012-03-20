class AddPinyinOriginalToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :pinyin_original, :string
  end
end
