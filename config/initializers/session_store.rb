# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_steam-demo_session',
  :secret      => 'd8df8eb9a84e6988d7a71e95f7925430ecc6d178c631037067a350b68b2979bbad516bf8a3fdb25b1fd2928ac40b3207798f52b73a21c701b9dc65f835e8b812'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
