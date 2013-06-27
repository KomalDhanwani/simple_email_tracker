require 'uuid'

module SimpleEmailTracker
  class Visit < ActiveRecord::Base
    before_create :set_uuid

    scope :search, lambda{ |key| where('simple_email_tracker_visits.key like ?', "%#{key}%") }

    def self.get_by_key(key,email)
      et = self.where("newsletter_id = ? && email = ?", key,email).first
      unless et.present?
        et = self.create({:newsletter_id => key, :key => key, :email => email})
      end
      et
    end

    def get_country_from_ip(request_ip)
      location = GeoIp.geocode_ip(request_ip)
      if location.present?
        [location.country_code2, location.country_name]
      else
        [nil,nil]
      end
    end


    def visit_by(request,email)
      puts("=============reques = #{request.inspect}")
      country = get_country_from_ip(request.ip)
      now = Time.zone.now
      self.count += 1
      self.first_visited_at = now unless self.first_visited_at
      self.last_visited_at = now
      self.ip = request.env["HTTP_X_FORWARDED_FOR"]
      self.country_code = country[0]
      self.country_name = country[1]
      self.user_agent = request.env["HTTP_USER_AGENT"]
      self.email = email
      self.save
    end

    private
    def set_uuid
      self.uuid = UUID.new.generate
    end
  end
end
