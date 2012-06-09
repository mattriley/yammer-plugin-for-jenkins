require 'oauth'

class YammerNotification < Jenkins::Tasks::Publisher

  display_name "Yammer Notification"

  def initialize(attrs = {})
    @consumer_key = attrs['consumer_key']
    @consumer_secret = attrs['consumer_secret']
    @oauth_key = attrs['oauth_key']
    @oauth_secret = attrs['oauth_secret']
    @group_id = attrs['group_id']
    @success_message = attrs['success_message']
    @unsuccessful_message = attrs['unsuccessful_message']
  end

  ##
  # Runs before the build begins
  #
  # @param [Jenkins::Model::Build] build the build which will begin
  # @param [Jenkins::Model::Listener] listener the listener for this build.
  def prebuild(build, listener)
  end

  ##
  # Runs the step over the given build and reports the progress to the listener.
  #
  # @param [Jenkins::Model::Build] build on which to run this step
  # @param [Jenkins::Launcher] launcher the launcher that can run code on the node running this build
  # @param [Jenkins::Model::Listener] listener the listener for this build.
  def perform(build, launcher, listener)
    message = build.native.getResult.to_s == 'SUCCESS' ? @success_message : @unsuccessful_message
    body = "#{build.native.getFullDisplayName} #{build.native.getResult.to_s}\n#{message}"
    listener.info 'Sending Yammer notification...'
    consumer = OAuth::Consumer.new @consumer_key, @consumer_secret, {:site => "https://www.yammer.com", :scheme => :header}
    token_hash = {:oauth_token => @oauth_key, :oauth_token_secret => @oauth_secret}
    access_token = OAuth::AccessToken.from_hash consumer, token_hash
    access_token.request :post, 'https://www.yammer.com/api/v1/messages.json', {:body => body, :group_id => @group_id}
    listener.info 'Yammer notification sent.'
  end

end