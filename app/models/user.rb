# User class
class User
  include Mongoid::Document
  authenticates_with_sorcery!

  field :email, type: String
  field :login, type: String
  field :admin, type: Boolean, default: false

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, presence: true, uniqueness: true
  validates :login, presence: true, length: { minimum: 3, maximum: 30 }, format: { with: /\A\w+\Z/ }, uniqueness: true

  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
end
