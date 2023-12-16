class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
    authorize! :index, @bookings
  end

  def user_bookings
    @bookings = Booking.where(user_id: current_user.id)
  end

  def create
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
    @booking = Booking.new(event_id: @event.id, user_id: @user.id)
    if @booking.save
      redirect_to root_path, notice: "You have booked #{@event.title}"
    else
      render :new
    end
  end
end