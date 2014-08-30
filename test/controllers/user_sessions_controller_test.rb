require 'test_helper'

describe UserSessionsController do
  describe 'test guest' do
    it 'should get new' do
      get :new
      assigns(:user).must_be_kind_of(User)
      assigns(:user).must_be(:new_record?)
      assert_response :success
    end
    it 'should get destroy' do
      get :destroy
      assert_redirected_to root_path
    end
    it 'should render new if session creation failed' do
      post :create, password: 'password', login: 'login'
      assert_template :new
    end
    it 'should redirect ro root if session creation success' do
      user = create(:user, login: 'login', password: 'password', password_confirmation: 'password')
      user.must_be :valid?
      post :create, password: 'password', login: 'login'
      assert_redirected_to root_path
    end
  end

  describe 'test authorized user' do
    before do
      user = create(:user)
      login_user(user)
    end

    it 'should redirect on new' do
      get :new
      assert_redirected_to root_path
    end

    it 'should logout and redirect on destroy' do
      get :destroy
      assert_redirected_to root_path
    end

    it 'should redirect on create' do
      post :create
      assert_redirected_to root_path
    end
  end
end
