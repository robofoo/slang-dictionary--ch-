class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin, :definition, :example, :email, :status
  before_create :create_code

  STATUSES = %w[raw confirmed reviewed flagged]
  validates_inclusion_of :status, :in => STATUSES, :message => "{{value}} must be in #{STATUSES.join(',')}"

  acts_as_voteable

  def accept(current_user)
    current_user.clear_votes(self)
    current_user.vote_for(self)

    # change to 'reviewed' if score is high enough
    if self.plusminus > 3
      self.status = 'reviewed'
    end
  end

  private

  def create_code
    self.code = SecureRandom.hex(6)
  end

  def self.random_unconfirmed(current_user)
    valid_defs = Definition.where(:status => 'confirmed')

    # don't show own submitted words
    valid_defs = valid_defs.where('email != ?', current_user.email) if current_user

    # don't show ones already voted on
    #valid_defs = valid_defs - current_user.

    if valid_defs.count > 0
      valid_defs.offset(rand(valid_defs.count)).first
    else
      valid_defs
    end
  end
end
