class Event < ActiveRecord::Base
  validates :sk_id, :uniqueness => true

  has_many :calendar_entries, dependent: :destroy
  has_many :users, through: :calendar_entries

  def self.parse_event_hash(event_hash)
    params = Hash.new
    params['kind'] = event_hash['type']
    params['display_name'] = event_hash['displayName']
    params['date'] = self.start_hash_to_date event_hash['start']
    params['time'] = self.start_hash_to_time event_hash['start']
    params['location'] = self.location_hash_to_city event_hash['location']
    params['uri'] = event_hash['uri']
    params['sk_id'] = event_hash['id']
    params['artist_id'] = event_hash['performance'][0]['artist']['id']
    return params
  end

  private
    def self.start_hash_to_date(start_hash)
      if start_hash['date']
        DateTime.parse(start_hash['date'])
      end
    end

    def self.start_hash_to_time(start_hash)
      if start_hash['time']
        DateTime.parse(start_hash['time'])
      end
    end

    def self.location_hash_to_city(location_hash)
      location_hash['city']
    end
end
