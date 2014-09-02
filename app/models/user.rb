# User class
class User
  include Mongoid::Document
  authenticates_with_sorcery!

  # login and email fields set in sorcery
  field :admin, type: Boolean, default: false

  embeds_many :payments do
    def total
      sum(:value)
    end
  end

  has_many :deals, before_add: :check_balance, before_remove: :do_not_remove do
    def total
      sum(:price)
    end
  end

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, presence: true, uniqueness: true
  validates :login, presence: true, length: { minimum: 3, maximum: 30 }, format: { with: /\A\w+\Z/ }, uniqueness: true

  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  def balance
    payments.total - deals.total
  end

  protected

  def check_balance(deal)
    fail InsufficientFunds.new, 'Недостаточно средств' if balance < deal.price
  end

  def do_not_remove(_)
    fail CantRemoveDealFromUser.new, 'У пользователя нельзя удалить сделку'
  end
end

class InsufficientFunds < StandardError
end

class CantRemoveDealFromUser < StandardError
end
