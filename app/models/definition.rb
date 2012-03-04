class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin, :definition, :example, :email

  default_scope where(:visible => true)
end
