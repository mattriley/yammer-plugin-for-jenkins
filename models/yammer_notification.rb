require File.expand_path(File.dirname(__FILE__) + '/notification_sender')

class YammerNotification < Jenkins::Tasks::Publisher

  attr_accessor :consumer_key, :consumer_secret, :oauth_key, :oauth_secret, :group_id, :success_message, :unsuccessful_message

  display_name "Yammer Notification"

  def initialize(attrs)
    @consumer_key = attrs['consumer_key']
    @consumer_secret = attrs['consumer_secret']
    @oauth_key = attrs['oauth_key']
    @oauth_secret = attrs['oauth_secret']
    @group_id = attrs['group_id']
    @success_message = attrs['success_message']
    @unsuccessful_message = attrs['unsuccessful_message']
  end

  def prebuild(build, listener)
  end

  def perform(build, launcher, listener)
    sender = NotificationSender.new build, listener, self
    sender.send_notification
  end

end