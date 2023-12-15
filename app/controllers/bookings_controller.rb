class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def new
    @event = Event.find(params[:event_id])
    @booking = @event.bookings.build
  end

  def create
    @event = Event.find(params[:booking][:event_id])
    @booking = @event.bookings.build(booking_params)
    if @booking.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:name, :email)
  end
end