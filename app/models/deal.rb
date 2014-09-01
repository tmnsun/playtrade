# User buy p1/p2/p3 account
class Deal
  include Mongoid::Document
  include SimpleEnum::Mongoid
  include Mongoid::Timestamps::Created

  belongs_to :account
  belongs_to :user

  field :disabled, type: Boolean, default: false
  field :price, type: Integer

  as_enum :type, p1: 1, p2: 2, p3: 3

  validates :price, numericality: { greater_than_or_equal_to: 0 }

  validates_presence_of :type, :account, :price

  before_validation :check_prev_user
  before_validation :check_prev_enabled
  before_validation :cant_disable_without_user

  before_destroy :dont_destroy_with_user

  def disabled?
    disabled
  end

  def enabled?
    !disabled?
  end

  def prev_deal
    same_deal.lt(created_at: created_at || Time.now).order_by(created_at: :desc).first
  end

  def next_deal
    return if new_record?
    same_deal.gt(created_at: created_at).order_by(created_at: :asc).first
  end

  protected

  def same_deal
    Deal.where(account: account, type_cd: type_cd)
  end

  def check_prev_user
    previous_deal = prev_deal

    return if previous_deal.nil? || previous_deal.user != user

    errors.add(:base, 'Cant make deal with same user for same account')
  end

  def check_prev_enabled
    previous_deal = prev_deal

    return if previous_deal.nil? || previous_deal.disabled?

    errors.add(:base, 'Cant make deal if previous_deal enabled')
  end

  def dont_destroy_with_user
    return false if user.present?
  end

  def cant_disable_without_user
    errors.add(:disabled, 'Cant set disabled without user') if disabled? && user.nil?
  end
end
