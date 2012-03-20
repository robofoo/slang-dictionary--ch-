class FixPinyinColName < ActiveRecord::Migration
  def change
    rename_column :definitions, :pinyin, :pinyin_for_search
  end
end
