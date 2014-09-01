# Balance payments
class Payment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :value, type: Integer

  embedded_in :user

  validates :value, presence: true
end
