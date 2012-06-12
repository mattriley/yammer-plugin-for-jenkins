require File.expand_path(File.dirname(__FILE__) + '/notification_sender')

class YammerNotification < Jenkins::Tasks::Publisher

  attr_reader :consumer_key, :consumer_secret, :oauth_key, :oauth_secret, :group_id,
              :send_success_notifications, :success_message, :send_failure_notifications, :failure_message

  display_name "Yammer Notification"

  def initialize(attrs)
    @consumer_key = attrs['consumer_key']
    @consumer_secret = attrs['consumer_secret']
    @oauth_key = attrs['oauth_key']
    @oauth_secret = attrs['oauth_secret']
    @group_id = attrs['group_id']
    @send_success_notifications = attrs['send_success_notifications']
    @success_message = attrs['success_message']
    @send_failure_notifications = attrs['send_failure_notifications']
    @failure_message = attrs['failure_message']
  end

  def prebuild(build, listener)
  end

  def perform(build, launcher, listener)
    return unless should_send_notification? build.native.getResult.to_s
    sender = NotificationSender.new build, listener, self
    sender.send_notification
  end

  def consumer_key_actual
    replace_blank @consumer_key, ENV['YAMMER.CONSUMER_KEY']
  end

  def consumer_secret_actual
    replace_blank @consumer_secret, ENV['YAMMER.CONSUMER_SECRET']
  end

  def oauth_key_actual
    replace_blank @oauth_key, ENV['YAMMER.OAUTH_KEY']
  end

  def oauth_secret_actual
    replace_blank @oauth_secret, ENV['YAMMER.OAUTH_SECRET']
  end

  private

  def should_send_notification?(build_result)
    (build_result == 'SUCCESS' && @send_success_notifications) || (build_result != 'SUCCESS' && @send_failure_notifications)
  end

  def replace_blank(value, replacement)
    blank?(value) ? replacement : value
  end

  def blank?(value)
    value.to_s.strip.length == 0
  end

end