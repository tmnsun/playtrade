require 'test_helper'

describe UsersController do
  it 'should show login page' do
    get :new
    assert_template :new
  end

  it 'must create account, authenticate and redirect to root page' do
    post :create, user: attributes_for(:user)
    assert_redirected_to root_path
  end

  it 'must render new template' do
    post :create, user: attributes_for(:user, login: nil)
    assert_template :new
  end
end
