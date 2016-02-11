class CalendarEntriesController < ApplicationController
  # Events will be handled by their sk_id
  def show
    @calendar_entry = CalendarEntry.find([params[:user_id]), params[:event_id])])
    @event = Event.find_by sk_id: @calendar_entry.event_id
  end

  def new
    @calendar_entry = CalendarEntry.new
  end
end
