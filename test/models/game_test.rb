require 'test_helper'

describe Game do
  # let(:game) { Game.new }

  it 'has valid factory' do
    create(:game).must_be :valid?
  end

  it 'is invalid without a title' do
    game = build(:game, title: nil)
    game.must_be :invalid?
    game.errors.must_include(:title)
  end

  it 'is invalid with duplicate title' do
    create(:game, title: 'The Duplicate')
    game = build(:game, title: 'The Duplicate')
    game.must_be :invalid?
    game.errors.must_include(:title)
  end

end

describe 'filter games by letter' do
  before :each do
    @quake = create(:game, title: 'Quake')
    @counter_strike = create(:game, title: 'Counter-Strike')
    @qad = create(:game, title: 'Qad')
  end

  context 'matching letters' do
    it 'returns an array of games that sorted by title that match' do
      assert_equal(Game.by_letter('Q').to_a, [@qad, @quake])
    end
  end

  context 'non-matching letters' do
    it 'returns an array of games that sorted by title that match' do
      refute_includes(Game.by_letter('Q').to_a, @counter_strike)
    end
  end
end

describe 'not in account' do
  before do
    @account = create(:account)
    @game1 = create(:game)
    @game2 = create(:game)
    @game3 = create(:game)
  end

  it 'should return all games' do
    assert_equal(Game.not_in_account(@account).to_a, [@game1, @game2, @game3])
  end

  it 'should return 1 and 3 game' do
    @account.games << @game2
    assert_equal(Game.not_in_account(@account).order_by(:title.asc).to_a, [@game1, @game3])
  end

  it 'should return empty array' do
    @account.games << @game1
    @account.games << @game2
    @account.games << @game3
    assert_equal(Game.not_in_account(@account).to_a, [])
  end
end
