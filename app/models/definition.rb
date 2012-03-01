class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin, :definition, :example, :email
end
