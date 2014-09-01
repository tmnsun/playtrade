# Account with games
class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :email_password, type: String
  field :password, type: String
  field :birthday, type: Date

  has_and_belongs_to_many :games
  has_many :deals  do
    def by_type(type)
      where(type_cd: type)
    end
  end

  def can_sell?(type)
    deal = last_deal(type)
    deal.nil? || deal.disabled?
  end

  def last_deal(type)
    type = type.to_i
    return nil unless correct_deal_type(type)
    deals.by_type(type).last
  end

  validates :email, email: true, uniqueness: true
  validates_presence_of :email, :email_password, :password

  protected

  def correct_deal_type(type)
    [1, 2, 3].include?(type)
  end
end
