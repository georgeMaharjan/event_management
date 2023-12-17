RSpec.shared_context 'when user with role user is signed in' do
  let(:ability) { Ability.new(user) }

  before do
    allow(Ability).to receive(:new).with(user).and_return(ability)
    allow(ability).to receive(:can?).with(:new, Event).and_return(false)
    allow(ability).to receive(:can?).with(:create, Event).and_return(false)
    allow(ability).to receive(:can?).with(:edit, Event).and_return(false)
    allow(ability).to receive(:can?).with(:update, Event).and_return(false)
    allow(ability).to receive(:can?).with(:destroy, Event).and_return(false)
    allow(ability).to receive(:can?).with(:index, Booking).and_return(false)
  end

  it 'redirects to root path with alert' do
    perform_action
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('You are not authorized to access this page.')
  end
end