class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@songkick.com\z/i

  before_save { self.email = email.downcase }
  validates :first_name, presence: true, length: { maximum: 25}
  validates :last_name, presence: true, length: { maximum: 50}
  validates :email, presence: true, length: { maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  has_many :calendar_entries, dependent: :destroy
  has_many :events, through: :calendar_entries

  include HTTParty
  format :json

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Saves calendar entries
  def save_calendar_entries_from_api
    uri = "http://api.songkick.com/api/3.0/users/#{sk_username}/calendar.json?reason=attendance&apikey=hackday"
    p uri
    response = HTTParty.get(uri)
    results_page = response['resultsPage']
    if (results_page['status'] == "error")
      return false
    elsif
      total_pages = (results_page['totalEntries']/results_page['perPage'].to_f).ceil
      page_no = 1
      CalendarEntry.where(user_id: self.id).destroy_all
      loop do
        results_page['results']['calendarEntry'].each do |entry|
          CalendarEntry.find_or_create_by(CalendarEntry.parse_calendar_entry(entry, self.id))
        end
        break if page_no == total_pages
        page_no += 1
        uri = "http://api.songkick.com/api/3.0/users/#{sk_username}/calendar.json?reason=attendance&page=#{page_no}&apikey=hackday"
        response = HTTParty.get(uri)
        results_page = response['resultsPage']
      end
    end
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
