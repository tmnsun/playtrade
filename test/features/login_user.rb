require 'test_helper'

feature 'Login User' do
  scenario "login user from root page" do
    visit root_path
    page.must_have_content 'Распродажа игр'
  end
end
