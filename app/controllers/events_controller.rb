class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
    @chatroom = @event.chatroom
    @message = Message.new
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.save
    if @event.save
      @chatroom = Chatroom.create(name: "Welcome to #{@event.title}", event: @event)
      redirect_to event_path(@event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    redirect_to event_path(@event)
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, status: :see_other
  end

  private

  def event_params
    params.require(:event).permit(:title, :location, :date, :description)
  end
end
