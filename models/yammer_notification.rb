require File.expand_path(File.dirname(__FILE__) + '/notification_data')
require File.expand_path(File.dirname(__FILE__) + '/notification_sender')

class YammerNotification < Jenkins::Tasks::Publisher

  display_name "Yammer Notification"

  def initialize(attrs)
    @attrs = attrs
  end

  def prebuild(build, listener)
  end

  def perform(build, launcher, listener)
    notification_data = NotificationData.new @attrs
    notification_sender = NotificationSender.new build, listener, notification_data
    notification_sender.send_notification
  end

  def method_missing(m, *args, &block)
    @attrs[m]
  end

end