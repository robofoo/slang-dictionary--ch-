class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin, :definition, :example, :email
  default_scope where(:visible => true, :confirmed => true)
  before_create :set_defaults, :create_code

  acts_as_voteable

  private

  def set_defaults
    # must set manually because of default_scope
    self.visible = false
    self.confirmed = false
    # returning false would prevent save so return nil
    nil
  end

  def create_code
    self.code = SecureRandom.hex(6)
  end

  def self.random_unconfirmed(user_signed_in)
    valid_defs = Definition.unscoped.where(:confirmed => false, :visible => false)

    if valid_defs.count > 0
      valid_defs.offset(rand(valid_defs.count)).first
    else
      valid_defs
    end
  end
end
