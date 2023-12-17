class BookingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_booking, only: %i[ destroy ]

  def index
    @bookings = Booking.all
  end

  def user_bookings
    @bookings = current_user.bookings
  end

  def create
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
    existing_booking = Booking.find_by(event_id: @event.id, user_id: @user.id)

    if existing_booking
      redirect_to root_path, alert: "You have already booked this event."
    else
      @booking = Booking.new(event: @event, user: @user)

      if @booking.save
        redirect_to user_bookings_path, notice: "You have booked #{@event.title}"
      end
    end
  end

  def destroy
    @booking.destroy!

    respond_to do |format|
      format.html { redirect_to user_bookings_path, notice: "Booking was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
  def set_booking
    @booking = Booking.find(params[:id])
  end
end
