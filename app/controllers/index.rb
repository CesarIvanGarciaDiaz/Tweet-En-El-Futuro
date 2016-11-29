require 'twitter'

get '/' do
  erb :index
end

get '/sign_in' do
  # El método `request_token` es uno de los helpers
  # Esto lleva al usuario a una página de twitter donde sera atentificado con sus credenciales
  redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")
  # Cuando el usuario otorga sus credenciales es redirigido a la callback_url
  # Dentro de params twitter regresa un 'request_token' llamado 'oauth_verifier'
end

get '/auth' do
  # Volvemos a mandar a twitter el 'request_token' a cambio de un 'access_token'
  # Este 'access_token' lo utilizaremos para futuras comunicaciones.
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # Despues de utilizar el 'request token' ya podemos borrarlo, porque no vuelve a servir.
  session.delete(:request_token)


  username = @access_token.params['screen_name']
  session[:oauth_token] = @access_token.params['oauth_token']
  session[:oauth_token_secret] = @access_token.params['oauth_token_secret']
  session[:username] = username

  if TwitterUser.find_by(username: session[:username])
    usuario = TwitterUser.find_by(username: session[:username])
    usuario.update(oauth_token: session[:oauth_token], oauth_token_secret: session[:oauth_token_secret])

    redirect to "/fetch"
  else
    TwitterUser.create(username: username, oauth_token: session[:oauth_token], oauth_token_secret: session[:oauth_token_secret])
    redirect to "/fetch"
  end
end

# Para el signout no olvides borrar el hash de session

post '/tweet' do
  new_tweet = params[:text]
      cliente= Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_KEY']
        config.consumer_secret     = ENV["TWITTER_SECRET"]
        config.access_token        = session[:oauth_token]
        config.access_token_secret = session[:oauth_token_secret]
      end
      #
      # user_created=TwitterUser.find_by(username: session[:username])
      # Tweet.create(id_tweet: user_created.id, tweet: new_tweet)
      cliente.update(new_tweet)

  # create_tweet(new_tweet)
  @tweet=(params[:text])
  erb :tweet
end

get '/fetch' do
  username=  session[:username]
  redirect to("/#{username}")
end

post '/buscar' do
  username = params[:twitter_handle]
  redirect to("/#{username}")
end

get '/:username' do

  @user=params[:username]

  imagen = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_KEY']
    config.consumer_secret     = ENV["TWITTER_SECRET"]
    config.access_token        = session[:oauth_token]
    config.access_token_secret = session[:oauth_token_secret]
  end
  user_data = imagen.user_search(@user).first
  @url = user_data.profile_image_url("original")

  @user_created=TwitterUser.find_or_create_by(username:@user)
  @tweets_temporal = Tweet.where(id_tweet: @user_created.id)

  if @tweets_temporal.empty?
    tweets_twitter=CLIENT.user_timeline("@#{@user}",result_type:"recent").take(10)
    tweets_twitter.each do |t|
      Tweet.create(id_tweet: @user_created.id, tweet: t.text)
    end
  end

  if Time.now - @tweets_temporal.last.created_at > 10
    tweets_twitter=CLIENT.user_timeline(@user,result_type:"recent").take(5)
    tweets_twitter.reverse_each do  |t|
      Tweet.create(id_tweet: @user_created.id, tweet: t.text)
    end
  end

  @tweets = Tweet.where(id_tweet: @user_created.id)
  erb :tweets
end
#**********************

post '/later/tweet' do
   # Recibe el input del usuario
   texto = params[:texto]
   user = TwitterUser.find_by(username: session[:username])
   id = user.tweet_later(texto)

   @message = "El Job Id es: #{id}"
 id

end

get '/status/:job_id' do
  # regresa el status de un job a una petición AJAX
  job_id = params[:job_id]
   if job_is_complete(job_id)
     message = "Se envio el tweet"
   else
     message = "No se ha enviado"
   end
end


#**********************

post '/exit' do
  session.delete(:oauth_token)
  session.delete(:oauth_token_secret)
  session.delete(:username)
  erb :index
end
