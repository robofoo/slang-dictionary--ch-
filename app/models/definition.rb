class Definition < ActiveRecord::Base
  validates_presence_of :word, :definition, :example
end
