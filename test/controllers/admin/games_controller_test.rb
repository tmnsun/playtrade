require 'test_helper'

describe Admin::GamesController do
  it 'must redirect to root if user is not admin' do
    user = create(:user)
    login_user(user)
    get :index
    assert_redirected_to root_path
  end

  describe 'admin user' do
    before do
      user = create(:admin_user)
      login_user(user)
    end

    it 'must render index template with all games' do
      get :index
      assert_template :index
      assigns(:games).must_be_kind_of(Mongoid::Criteria)
      assert_equal assigns(:games).count, Game.count
    end

    it 'must update game and redirect to index' do
      game = create(:game, title: 'old_title')
      post :update, id: game.id, game: attributes_for(:game, title: 'new_title')
      game.reload
      assert_equal game.title, 'new_title'
      assert_redirected_to admin_game_path(game)
    end

    it 'must create game and redirect to index' do
      games_count = Game.count
      post :create, game: attributes_for(:game, title: 'new_title')
      assert_equal(games_count + 1, Game.count)
      assert_redirected_to admin_game_path(Game.first)
    end

    it 'must render new form' do
      post :create, game: attributes_for(:game, title: nil)
      assert_template :new
    end
  end
end
