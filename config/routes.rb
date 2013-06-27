SimpleEmailTracker::Engine.routes.draw do
  match "/:uuid/:newsletter_id(/:email)/t.gif", controller: :email_trackers, action: :show, :constraints => {:email => /[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}/i}
  match "/", controller: :email_trackers, action: :index
end
