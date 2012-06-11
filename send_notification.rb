require 'bundler/setup'
require File.expand_path(File.dirname(__FILE__) + '/models/yammer')

yam = Yammer.new ARGV[0], ARGV[1], ARGV[2], ARGV[3]
yam.send_message ARGV[4], ARGV[5]