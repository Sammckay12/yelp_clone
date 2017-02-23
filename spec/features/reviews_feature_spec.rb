require 'rails_helper'

feature 'reviewing' do
  before do
    @user = User.create(email: 'test@test.com', password: 'test123')
    @restaurant = Restaurant.create(name: 'burgers', user: @user)
  end

  scenario 'allows users to leave a review using a form' do
     sign_in
     visit '/restaurants'
     click_link 'Review burgers'
     fill_in "Thoughts", with: "great"
     select '3', from: 'Rating'
     click_button 'Leave Review'

     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('great')
  end

end
