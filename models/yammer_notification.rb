require 'timeout'
require File.expand_path(File.dirname(__FILE__) + '/yammer')

class YammerNotification < Jenkins::Tasks::Publisher

  attr_accessor :consumer_key, :consumer_secret, :oauth_key, :oauth_secret, :group_id, :success_message, :unsuccessful_message

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
    listener.info 'Sending Yammer notification...'
    message_sender = Yammer.new @consumer_key, @consumer_secret, @oauth_key, @oauth_secret

    begin
      Timeout::timeout 10 do
        message_sender.send_message message(build), @group_id
        listener.info 'Yammer notification sent.'
      end
    rescue => e
      jruby_version = `jruby -v`
      if jruby_version =~ /ruby-1.9/
        listener.info 'Result of Yammer notification could not be determined due to a compatibility issue.'
        listener.info jruby_version
      else
        listener.error 'Yammer notification was not sent.'
        listener.error e.message
        listener.error e.backtrace
      end
    end
  end

  private

  def message(build)
    message = build.native.getResult.to_s == 'SUCCESS' ? @success_message : @unsuccessful_message
    "#{build.native.getFullDisplayName} #{build.native.getResult.to_s}\n#{message}"
  end

end