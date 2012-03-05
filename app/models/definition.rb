class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin, :definition, :example, :email

  default_scope where(:visible => true)

  before_create :set_defaults
  before_save :create_code

  private

  def set_defaults
    self.visible = false
    # returning false would prevent save so return nil
    nil
  end

  def create_code
    self.code = SecureRandom.hex(6)
  end
end
