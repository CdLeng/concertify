require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "#{ENV["SPOTIFY_CLIENTID"]}", "#{ENV["SPOTIFY_CLIENTSECRET"]}", scope: 'user-read-email user-follow-read user-library-read'
end

OmniAuth.config.allowed_request_methods = [:post, :get]
