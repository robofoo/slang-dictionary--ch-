class AddStrippedPinyinToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :pinyin_with_tones, :string
  end
end
