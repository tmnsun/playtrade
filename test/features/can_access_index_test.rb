require "test_helper"

feature "CanAccessIndex" do
  scenario "has content" do
    visit root_path
    page.must_have_content 'Распродажа игр'
  end
end
