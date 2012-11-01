#-*- coding: utf-8 -*-

require 'twitter'
require 'kconv'
require 'pit'
require 'pp'

def oauth
  pit = Pit.get('twitter_api', 'require' => {
    :consumer_key => "an application's consumer key",
    :consumer_secret => "an application's consumer secret",
    :oauth_token => "a user's access token",
    :oauth_token_secret => "a user's access secret"
  })

  Twitter.configure do |config|
    config.consumer_key = pit['consumer_key']
    config.consumer_secret = pit['consumer_secret']
    config.oauth_token = pit['oauth_token']
    config.oauth_token_secret = pit['oauth_token_secret']
  end
end

oauth

begin
  tweets = Twitter.search(ARGV.join('').toutf8, lang: 'ja', count: 100)
rescue => e
  puts e.message
  exit
end

tweets[:statuses].each do |tweet|
  puts '-'*50

  printf "%s\n[%s/%s]@%s (%s)\n\n%s\n\n",
    tweet[:created_at],
    tweet[:user][:friend_count],
    tweet[:user][:follower_count],
    tweet[:user][:screen_name],
    tweet[:user][:name],
    tweet[:text].gsub(/\n/, ' ')

  print 'Open?(y/n/q) :'
  input = STDIN.gets.chomp
  puts "\n"

  if input == 'y'
    `chrome http://twitter.com/#{tweet[:user][:screen_name]}/status/#{tweet[:id]}`
  elsif input == 'q'
    exit
  end

end



