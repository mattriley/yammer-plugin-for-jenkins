require 'oauth'

class Yammer

  def initialize(consumer_key, consumer_secret, oauth_key, oauth_secret)
    @consumer_key = consumer_key
    @consumer_secret = consumer_secret
    @oauth_key = oauth_key
    @oauth_secret = oauth_secret
  end

  def send_message(message, group_id)
    consumer = OAuth::Consumer.new @consumer_key, @consumer_secret, :site => 'https://www.yammer.com'
    access_token = OAuth::AccessToken.from_hash consumer, :oauth_token => @oauth_key, :oauth_token_secret => @oauth_secret
    response = access_token.post 'https://www.yammer.com/api/v1/messages.json', {:body => message, :group_id => group_id}
    response.value
  end

end