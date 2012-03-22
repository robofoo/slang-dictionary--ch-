class Definition < ActiveRecord::Base
  validates_presence_of :word, :pinyin_original, :definition, :example, :email, :status
  before_create :create_code, :prepare_pinyin_for_search

  # raw - when anon users submits a word
  # confirmed - anon user clicks email link to confirm word
  # reviewed - words we show - editors have reviewed and like the word
  # flagged - words we hide - words under review by editors after flagged by users
  STATUSES = %w[raw confirmed reviewed flagged]
  validates_inclusion_of :status, :in => STATUSES, :message => "{{value}} must be in #{STATUSES.join(',')}"

  acts_as_voteable

  def accept(current_user)
    current_user.vote_exclusively_for(self)

    up_score

    # upgrade status to 'reviewed' if score is high enough
    if self.plusminus > 0
      self.status = 'reviewed'
      self.save!
    end
  end

  def reject(current_user)
    current_user.vote_exclusively_against(self)

    down_score

    # downgrade status to 'flagged' if score is low enough
    if self.plusminus < -5
      self.status = 'flagged'
      self.save!
    end
  end

  # nicely formatted pinyin to use in views
  # turn "ni3hao3ma5"
  # into "ni3 hao3 ma5"
  def pinyin
    if self.pinyin_original
      self.pinyin_original.gsub(/(\d)/, '\1 ').rstrip
    else
      ''
    end
  end

  private

  def up_score
    self.score = self.score + 1
  end

  def down_score
    self.score = self.score - 1
  end

  def create_code
    self.code = SecureRandom.hex(6)
  end

  def prepare_pinyin_for_search
    # also strip spaces
    self.pinyin_for_search = self.pinyin_original.gsub(/\d/, '').gsub(' ', '')
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
