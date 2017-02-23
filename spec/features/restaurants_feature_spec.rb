require 'rails_helper'

feature 'restaurants' do
  before do
    sign_in
  end
  context 'restaurants have been added' do
    before do
      @user = User.create(email: 'test@test.com', password: 'test123')
      Restaurant.create(name: 'KFC', user: @user)
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'creating restaurants' do
    before do
      User.create(email: 'test@test.com', password: 'test123')
    end
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        sign_in
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        fill_in 'Description', with: "Finger lickin' chicken"
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'the app does not let you submit a name that is too short' do
        sign_in
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
  end

  context 'viewing restaurants' do
    before do
      @user = User.create(email: 'test@test.com', password: 'test123')
    end

    let!(:kfc){ @user.restaurants.create(name:'KFC') }

    scenario 'lets a user view a restaurant' do
      visit '/'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

  context 'editing restaurants' do

    before do
      @user = User.create(email: 'test@test.com', password: 'test123')
      @restaurant = Restaurant.create(name: 'KFC', user: @user)
    end

    scenario 'let a user edit a restaurant' do
      sign_in
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      click_link 'Kentucky Fried Chicken'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(page).to have_content 'Deep fried goodness'
      expect(current_path).to eq "/restaurants/#{@restaurant.id}"
    end
  end

  context 'deleting restaurants' do

    before do
      @user = User.create(email: 'test@test.com', password: 'test123')
      @restaurant = Restaurant.create(name: 'KFC', description: 'Deep fried goodness', user: @user)
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      sign_in
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'You have deleted restaurant successfully'
    end

  end
end
