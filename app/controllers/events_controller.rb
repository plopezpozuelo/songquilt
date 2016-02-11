class EventsController < ApplicationController
  # Events will be handled by their sk_id
  def show
    @event = Event.find(params[:sk_id])
  end

  def new
    @event = Event.new
  end
end
