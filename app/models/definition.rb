class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin, :definition, :example, :email

  default_scope where(:visible => true)

  after_create :create_code

  private

  def create_code
    self.code = SecureRandom.hex(6)
  end
end
