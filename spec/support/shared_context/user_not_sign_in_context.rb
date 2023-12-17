RSpec.shared_context 'when user is not signed in' do
  before do
    sign_out user
  end

  it 'redirects to root path with alert' do
    perform_action
    expect(response).to redirect_to(new_user_session_path)
    expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
  end
end