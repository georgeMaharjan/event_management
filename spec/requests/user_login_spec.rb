require 'rails_helper'

RSpec.feature 'User Login' do
  let(:user) { create(:user) }

  context 'with correct credentials' do
    it 'allows the user to log in' do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'

      expect(page).to have_content 'Signed in successfully.'
      expect(current_path).to eq(root_path) # Adjust to your actual redirect path after login
    end
  end

  context 'with incorrect credentials' do
    it 'does not allow the user to log in' do
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'wrong_password'
      click_button 'Log in'

      expect(current_path).to eq(new_user_session_path)
    end
  end
end