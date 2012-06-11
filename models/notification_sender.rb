require 'timeout'
require File.expand_path(File.dirname(__FILE__) + '/yammer')

class NotificationSender

  TIMEOUT_IN_SECONDS = 10

  def initialize(build, listener, notification_data)
    @build = build
    @listener = listener
    @data = notification_data
  end

  def send_notification
    @listener.info 'Sending Yammer notification...'
    send_notification_rescue
  end

  private

  def send_notification_rescue
    begin
      send_notification_timeout
    rescue TimeoutError
      ruby_19? ? write_compatibility_issue_message : write_timeout_message
    rescue => e
      write_error_message e
    end
  end

  def send_notification_timeout
    Timeout::timeout(TIMEOUT_IN_SECONDS) { send_notification_actual }
  end

  def send_notification_actual
    yam = Yammer.new @data.consumer_key_actual, @data.consumer_secret_actual, @data.oauth_key_actual, @data.oauth_secret_actual
    yam.send_message message, @data.group_id
    @listener.info 'Yammer notification sent.'
  end

  def message
    build_result = @build.native.getResult.to_s
    message = build_result == 'SUCCESS' ? @data.success_message : @data.unsuccessful_message
    "#{@build.native.getFullDisplayName} #{build_result}\n#{message}"
  end

  def ruby_19?
    jruby_version =~ /ruby-1.9/
  end

  def jruby_version
    `jruby -v`
  end

  def write_compatibility_issue_message
    @listener.info ['Result of Yammer notification could not be determined due to a compatibility issue with Ruby 1.9.',
                    'For more information, see https://github.com/mattriley/yammer-plugin-for-jenkins/issues/1',
                    jruby_version] * "\n"
  end

  def write_timeout_message
    @listener.error 'Yammer notification timed out before result could be determined.'
  end

  def write_error_message(e)
    @listener.error ['An unexpected error occurred while sending the Yammer notification.', e.message, e.backtrace] * "\n"
  end

end