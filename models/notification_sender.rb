require 'timeout'

class NotificationSender

  TIMEOUT_IN_SECONDS = 60

  def initialize(build, listener, notification_data)
    @build = build
    @listener = listener
    @data = notification_data
  end

  def send_notification
    @listener.info 'Sending Yammer notification...'
    try_send_notification
  end

  private

  def try_send_notification
    begin
      send_notification_with_timeout
      @listener.info 'Yammer notification sent.'
    rescue TimeoutError
      @listener.error 'Yammer notification timed out before result could be determined.'
    rescue => e
      @listener.error ['An unexpected error occurred while sending the Yammer notification.', e.message, e.backtrace] * "\n"
    end
  end

  def send_notification_with_timeout
    Timeout::timeout(TIMEOUT_IN_SECONDS) { @listener.info exec_jruby_command }
  end

  def exec_jruby_command
    output = `#{jruby_command} 2>&1`
    raise output unless $?.success?
  end

  def jruby_command
    %Q[jruby --1.8 send_notification.rb #{@data.consumer_key} #{@data.consumer_secret} #{@data.oauth_key} #{@data.oauth_secret} "#{message}" #{@data.group_id}]
  end

  def message
    message = @build.native.getResult.to_s == 'SUCCESS' ? @data.success_message : @data.unsuccessful_message
    "#{@build.native.getFullDisplayName} #{@build.native.getResult.to_s}\n#{message}"
  end

end



