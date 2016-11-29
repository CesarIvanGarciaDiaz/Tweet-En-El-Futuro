class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)

    tweet = Tweet.find(tweet_id)
    p tweet
    puts ('*'*100)
      # user = # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet
      user = TwitterUser.find(tweet.id_tweet)
      p user
        puts ('-'*100)
      id = user.tweet(tweet.tweet)
        puts ('/'*100)
      # Manda a llamar el método del usuario que crea un tweet (user.tweet)
  
   tweet.update(tweet_id: id.id)
  #
  #         cliente= Twitter::REST::Client.new do |config|
  #           config.consumer_key        = ENV['TWITTER_KEY']
  #           config.consumer_secret     = ENV["TWITTER_SECRET"]
  #           config.access_token        = session[:oauth_token]
  #           config.access_token_secret = session[:oauth_token_secret]
  #         end
  #         #
  #         # user_created=TwitterUser.find_by(username: session[:username])
  #         # Tweet.create(id_tweet: user_created.id, tweet: new_tweet)
  #         cliente.update(new_tweet)
  #
  # cliente.update(tweet.tweet)
  end

end
