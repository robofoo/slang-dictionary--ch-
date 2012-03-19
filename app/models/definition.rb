class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin_with_tones, :definition, :example, :email, :status
  before_create :create_code, :strip_pinyin_tones, :space_pinyin_with_tones

  # raw - when anon users submits a word
  # confirmed - anon user clicks email link to confirm word
  # reviewed - words we show - editors have reviewed and like the word
  # flagged - words we hide - words under review by editors after flagged by users
  STATUSES = %w[raw confirmed reviewed flagged]
  validates_inclusion_of :status, :in => STATUSES, :message => "{{value}} must be in #{STATUSES.join(',')}"

  acts_as_voteable

  def accept(current_user)
    current_user.clear_votes(self)
    current_user.vote_for(self)

    # upgrade status to 'reviewed' if score is high enough
    if self.plusminus > 3
      self.status = 'reviewed'
    end
  end

  def reject(current_user)
    current_user.clear_votes(self)
    current_user.vote_against(self)

    # downgrade status to 'flagged' if score is low enough
    if self.plusminus < -3
      self.status = 'flagged'
    end
  end

  private

  def create_code
    self.code = SecureRandom.hex(6)
  end

  def strip_pinyin_tones
    # also strip spaces
    self.pinyin = self.pinyin_with_tones.gsub(/\d/, '').gsub(' ', '')
  end

  # turn "ni3hao3ma5"
  # into "ni3 hao3 ma5"
  def space_pinyin_with_tones
    self.pinyin_with_tones.gsub!(/(\d)/, '\1 ').rstrip!
  end

  def self.random_unconfirmed(current_user = nil)
    valid_defs = Definition.where(:status => 'confirmed')

    # don't show own submitted words
    valid_defs = valid_defs.where('email != ?', current_user.email) if current_user

    # don't show definitions user already voted on
    if current_user
      voteable_ids = Vote.find(current_user.vote_ids).map { |v| v.voteable_id }
      voted_by_user = Definition.find(voteable_ids)
      valid_defs = valid_defs - voted_by_user
    end

    if valid_defs.count > 0
      if valid_defs.class == Array
        valid_defs[rand(valid_defs.size)]
      else
        valid_defs.offset(rand(valid_defs.count)).first
      end
    else
      valid_defs
    end
  end
end
