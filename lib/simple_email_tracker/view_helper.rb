module SimpleEmailTracker
  module ViewHelper
    def set_email_tracker *args
      et = SimpleEmailTracker::Visit.get_by_key(args.first, args.second)
      image_tag "#{root_url}email_trackers/#{et.uuid}/#{args.first}/#{args.second}/t.gif"
    end
  end
end
