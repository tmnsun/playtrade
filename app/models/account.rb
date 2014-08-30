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
    return false unless [1, 2, 3].include?(type)
    last_deal = deals.by_type(type).last
    last_deal.nil? || last_deal.disabled?
  end

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, presence: true, uniqueness: true
  validates :email_password, presence: true
  validates :password, presence: true
end
