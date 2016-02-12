class EventsController < ApplicationController
  # Events will be handled by their sk_id
  def show
    @event = Event.find_by(sk_id: params[:id])
    @calendar_entries = CalendarEntry.where(event_id: params[:id])
    @going = User.find(@calendar_entries.where(reason: 'im_going').pluck(:user_id))
    @might_go = User.find(@calendar_entries.where(reason: 'i_might_go').pluck(:user_id))
  end

  def new
    @event = Event.new
  end
end
