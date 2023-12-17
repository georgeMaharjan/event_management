require 'rails_helper'
require './spec/support/shared_context/user_not_sign_in_context.rb'
require './spec/support/shared_context/user_not_authorized_context.rb'

RSpec.describe BookingsController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user, name: 'user 1') }
  let(:user2) { create(:user, name: 'user 2') }
  let(:event1) { create(:event, title: 'Event 1', location: 'Location 1', status: :upcoming) }
  let(:event2) { create(:event, title: 'Event 2', location: 'Location 2', status: :registered) }
  let(:booking1) { create(:booking, user_id: user1.id, event_id: event1.id) }
  let(:booking2) { create(:booking, user_id: user2.id, event_id: event2.id) }
  let(:admin) { create(:user, role: :admin) }
  let(:ability) { Ability.new(admin) }

  describe 'GET #index' do
    context 'when admin is logged in' do
      before do
        sign_in admin
      end

      before do
        allow(Ability).to receive(:new).with(admin).and_return(ability)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end

      it 'assigns all bookings' do
        get :index
        expect(assigns(:bookings)).to match_array([booking1, booking2])
      end
    end

    context 'when user is logged in' do
      before do
        sign_in user
      end

      let(:perform_action) { get :index }
      include_context 'when user with role user is signed in'
    end

    context 'when no user is logged in' do
      include_context 'when user is not signed in'
      let(:perform_action) { get :index }
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before do
        sign_in user1
      end

      context 'with valid params' do
        it 'creates a new booking' do
          post :create, params: { event_id: event1.id, user_id: user1.id }
          expect(response).to redirect_to(user_bookings_path)
          expect(flash[:notice]).to eq("You have booked #{event1.title}")
        end
      end

      context 'when user has already booked the event' do
        let!(:existing_booking) { create(:booking, event: event1, user: user1) }

        it 'redirects with an alert' do
          post :create, params: { event_id: event1.id, user_id: user1.id }
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('You have already booked this event.')
        end
      end
    end

    context 'when no user is logged in' do
      include_context 'when user is not signed in'
      let(:perform_action) { post :create, params: { event_id: event1.id, user_id: user1.id } }
    end
  end

  describe 'GET #user_bookings' do
    context 'when user is logged in' do
      before do
        sign_in user1
      end

      it 'assigns user bookings to @bookings' do
        get :user_bookings
        expect(assigns(:bookings)).to eq([booking1])
        expect(response).to render_template(:user_bookings)
      end
    end

    context 'when no user is logged in' do
      include_context 'when user is not signed in'
      let(:perform_action) { get :user_bookings }
    end
  end
end
