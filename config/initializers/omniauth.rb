Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Settings.twitter.consumer_key, Settings.twitter.consumer_secret
  provider :facebook, Settings.facebook.app_id, Settings.facebook.app_secret,:scope => 'read_stream,publish_stream,offline_access,user_education_history,friends_education_history,user_work_history,friends_work_history,user_about_me,friends_about_me,user_activities,friends_activities,user_birthday,friends_birthday',:display => 'popup', :client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}
end