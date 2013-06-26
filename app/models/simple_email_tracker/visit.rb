require 'uuid'

module SimpleEmailTracker
  class Visit < ActiveRecord::Base
    before_create :set_uuid

    scope :search, lambda{ |key| where('simple_email_tracker_visits.key like ?', "%#{key}%") }

    def self.get_by_key key
      key = key.join(".") if key.kind_of? Array
      et = self.find_or_create_by_key key
    end

    def get_country_from_ip(request_ip)
      location = GeoIp.geocode_ip(request_ip)
      if location.present?
        [location.country_code2, location.country_name]
      else
        [nil,nil]
      end
    end


    def visit_by request
      country = get_country_from_ip(request.ip)
      now = Time.now
      self.count += 1
      self.first_visited_at = now unless self.first_visited_at
      self.last_visited_at = now
      self.ip = request.ip
      self.country_code = country[0]
      self.country_name = country[1]
      self.user_agent = request.env["HTTP_USER_AGENT"]
      self.save
    end

    private
    def set_uuid
      self.uuid = UUID.new.generate
    end
  end
end
