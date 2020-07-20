class Answer < ApplicationRecord
  validates :content, presence: true
  # validates :words_in_content, length: { minimum: 3 }, allow_blank: true
  #done FIXME_AB:  min words validation

  belongs_to :user
  belongs_to :question, counter_cache: true
  has_many :comments, as: :commentable
  has_many :votes, as: :votable
  has_many :credit_transactions, as: :creditable

  before_create :ensure_questions_belongs_to_other_user, :ensure_question_published
  after_commit :give_net_upvote_based_credit, if: Proc.new {|ans| ans.votes.exists? }

  def words_in_content
    content.scan(/\w+/)
  end

  private def ensure_questions_belongs_to_other_user
    if user == question.user
      errors.add(:base, 'Cannot answer your own question.')
      throw :abort
    end
  end

  private def ensure_question_published
    unless question.published?
      errors.add(:base, 'Cannot answer unpublished question.')
      throw :abort
    end
  end

  private def give_net_upvote_based_credit
    if net_upvotes >= 2 #ENV['upvote_for_bonus_credit'].to_i
      if credit_transactions.sum(:value).zero?
        credit_transactions.create(user: user, value: 1, reason: "upvotes bonus add")
      end
    else
      unless credit_transactions.sum(:value).zero?
        credit_transactions.create(user: user, value: -1, reason: "upvotes bonus remove")
      end
    end
  end
end
