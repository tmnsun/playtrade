# PS4 Game
class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String

  mount_uploader :cover, CoverUploader

  has_and_belongs_to_many :accounts

  validates :title, presence: true, uniqueness: true

  def self.by_letter(letter)
    Game.where(title: Regexp.new("^#{letter}", true)).asc(:title).all
  end

  def self.not_in_account(account)
    Game.not_in(id: account.game_ids).all
  end
end
