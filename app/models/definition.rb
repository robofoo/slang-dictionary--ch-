class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin, :definition, :example, :email
  default_scope where(:visible => true)
  before_create :set_defaults, :create_code

  private

  def set_defaults
    # must set manually because of default_scope
    self.visible = false
    # returning false would prevent save so return nil
    nil
  end

  def create_code
    self.code = SecureRandom.hex(6)
  end
end
