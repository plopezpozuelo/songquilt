class CalendarEntry < ActiveRecord::Base

  belongs_to :user
  belongs_to :event
  validates :user_id, presence: true
  validates :event_id, presence: true

  def self.parse_calendar_entry(calendar_entry_hash = {}, user_id)
    params = Hash.new
    params['user_id'] = user_id
    params['event_id'] = calendar_entry_hash['event']['id']
    params['reason'] = self.parse_reason(calendar_entry_hash['reason'])
    #Event.find_or_create_by(Event.parse_event_hash(calendar_entry_hash['event']))
    if !Event.find_by sk_id: calendar_entry_hash['event']['id']
      Event.create(Event.parse_event_hash(calendar_entry_hash['event']))
    end
    return params
  end

  private
    def self.parse_reason(reason = {})
      # For now, we are only interested in I'm going,
      # Tracking and Artist track, we don't want to
      # get back the artist the user is interested in.
      if reason.include? 'attendance'
        reason['attendance']
      elsif reason.include? 'tracked_artist'
        'tracked_artist'
      end
    end
end
