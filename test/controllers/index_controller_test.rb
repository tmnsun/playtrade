require 'test_helper'

describe IndexController do
  describe 'index action' do
    before do
      get :index
    end
    it 'should assign accounts' do
      assigns(:accounts).must_be_kind_of(Mongoid::Criteria)
    end
    it 'should render index template' do
      assert_template('index')
    end
  end
end
