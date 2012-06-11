class NotificationData

  attr_accessor :consumer_key, :consumer_secret, :oauth_key, :oauth_secret, :group_id, :success_message, :unsuccessful_message

  def initialize(attrs)
    @consumer_key = attrs['consumer_key']
    @consumer_secret = attrs['consumer_secret']
    @oauth_key = attrs['oauth_key']
    @oauth_secret = attrs['oauth_secret']
    @group_id = attrs['group_id']
    @success_message = attrs['success_message']
    @unsuccessful_message = attrs['unsuccessful_message']
  end

end