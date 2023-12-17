require 'rails_helper'
require './spec/support/shared_context/user_not_sign_in_context.rb'
require './spec/support/shared_context/user_not_authorized_context.rb'

RSpec.describe EventsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: :admin) }
  let(:event1) { create(:event, title: 'Event 1', location: 'Location 1', status: :upcoming) }
  let(:event2) { create(:event, title: 'Event 2', location: 'Location 2', status: :registered) }

  let(:ability) { Ability.new(admin) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context'when any user is signed in' do
      let(:ability) { Ability.new(user) }

      before do
        allow(Ability).to receive(:new).with(user).and_return(ability)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template :index
      end

      it 'assigns all events when no filters are applied' do
        get :index
        expect(assigns(:events)).to match_array([event1, event2])
      end

      it 'filters events by title' do
        get :index, params: { title: 'Event 1' }
        expect(assigns(:events)).to eq([event1])
      end

      it 'filters events by location' do
        get :index, params:  {location: 'Location 2' }
        expect(assigns(:events)).to eq([event2])
      end

      it 'filters events by status' do
        get :index, params: { status: 0 }
        expect(assigns(:events)).to eq([event2])
      end
    end

    context 'when user is not signed in' do
      include_context 'when user is not signed in'
      let(:perform_action) { get :index }
    end
  end

  describe 'GET #show' do
    context 'when user is signed in' do
      let(:ability) { Ability.new(user) }
      before do
        allow(Ability).to receive(:new).with(user).and_return(ability)
      end

      it 'renders the show template' do
        get :show, params: { id: event1.id }
        expect(response).to render_template :show
      end

      it 'assigns requested event to event' do
        get :show, params: { id: event1.id }
        expect(assigns(:event)).to eq(event1)
      end
    end

    context 'when user is not signed in' do
      include_context 'when user is not signed in'
      let(:perform_action) { get :show, params: { id: event1.id } }
    end
  end

  describe 'GET #new' do
    context 'when admin is signed in' do
      before do
        allow(Ability).to receive(:new).with(admin).and_return(ability)
      end

      before do
        sign_in admin
      end

      it 'assigns requested event to event' do
        get :new
        expect(assigns(:event)).to be_a_new(Event)
      end

      it 'renders the new form for event' do
        get :new
        expect(response).to render_template :new
      end
    end

    context 'user with role user is signed in' do
      let(:perform_action) { get :new }
      include_context 'when user with role user is signed in'
    end

    context 'when user is not signed in' do
      let(:perform_action) { get :new }
      include_context 'when user is not signed in'
    end
  end

  describe 'POST #create' do
    context 'when admin is signed in' do
      before do
        allow(Ability).to receive(:new).with(admin).and_return(ability)
      end

      before do
        sign_in admin
      end

      it 'creates a new event and redirects to the show page' do
        post :create, params: { event: attributes_for(:event) }
        expect(response).to redirect_to(event_path(Event.last))
        expect(flash[:notice]).to eq('Event was successfully created.')
      end

      it 'renders the new template when save fails' do
        allow_any_instance_of(Event).to receive(:save).and_return(false)
        post :create, params: { event: attributes_for(:event) }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is signed in' do
      include_context 'when user with role user is signed in'
      let(:perform_action) { post :create, params: { event: attributes_for(:event) } }
    end

    context 'when admin is not signed in' do
      include_context 'when user is not signed in'
      let(:perform_action) { post :create }
    end
  end

  describe 'GET #edit' do
    context 'when admin is signed in' do
      before do
        allow(Ability).to receive(:new).with(admin).and_return(ability)
      end
      before do
        sign_in admin
      end

      it 'renders the edit form for event' do
        get :edit, params: { id: event1.id }
        expect(response).to render_template :edit
      end
    end

    context 'when user is signed in' do
      include_context 'when user with role user is signed in'
      let(:perform_action) { get :edit, params: { id: event1.id } }
    end

    context 'when admin is not signed in' do
      include_context 'when user is not signed in'
      let(:perform_action) { get :edit, params: { id: event1.id } }
    end
  end

  describe 'PUT #update' do
    let(:updated_event) do
      {
        id: event1.id,
        event: {
          title: 'updated title',
          date: event1.date,
          location: event1.location,
          description: event1.description,
          status: event1.status
        }
      }
    end

    context 'when admin is signed in' do
      before do
        sign_in admin
      end

      before do
        allow(Ability).to receive(:new).with(admin).and_return(ability)
      end

      it 'updates a new event and redirects to the show page' do
        put :update, params: updated_event
        event1.reload
        expect(event1.title).to eq('updated title')
        expect(response).to redirect_to(event_path(event1))
        expect(flash[:notice]).to eq('Event was successfully updated.')
      end

      it 'renders the new template when update fails' do
        allow_any_instance_of(Event).to receive(:save).and_return(false)
        put :update, params: updated_event
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is signed in' do
      include_context 'when user with role user is signed in'
      let(:perform_action) { patch :update, params: updated_event }
    end

    context 'when admin is not signed in' do
      include_context 'when user is not signed in'
      let(:perform_action) { patch :update, params: updated_event }
    end
  end

  describe 'DELETE #destroy' do
    context 'when admin is signed in' do
      before do
          allow(Ability).to receive(:new).with(admin).and_return(ability)
      end

      before do
        sign_in admin
      end

      it 'deletes the requested event' do
        delete :destroy, params: { id: event1.id }
        expect(response).to redirect_to(events_path)
        expect(flash[:notice]).to eq('Event was successfully destroyed.')
      end
    end

    context 'when user with role user is signed in' do
      include_context 'when user with role user is signed in'
      let(:perform_action) { delete :destroy, params: { id: event1.id } }
    end

    context 'when admin is not signed in' do
      include_context 'when user is not signed in'
      let(:perform_action) { delete :destroy, params: { id: event1.id } }
    end
  end
end
