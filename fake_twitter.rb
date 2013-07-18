require 'rubygems'
require 'sinatra'
require 'haml'

require 'sinatra/activerecord'
configure(:development){ set :database, "sqlite3:///fake_twitter.sqlite3" }

require './models'

get '/' do
  @users = User.all
	haml :home
end

get '/sign_in' do
  haml :sign_in
end

post '/sign_in' do
  @user = User.where(:username => params[:username]).first
  if @user
    if @user.password == params[:password]
      redirect '/users/' + @user.id.to_s
    else
      params[:alert] = "Your password was wrong."
      redirect '/'
    end
  else
    redirect '/users/sign_up'
  end
end

get '/users/sign_up' do
  haml :sign_up
end

post '/users/sign_up' do
  User.create(params)
  @users = User.all
  redirect '/'
end

post '/users/:id/tweets/new' do
  @tweet = Tweet.create(:text => params[:tweet])
  @user = User.find(params[:id])
  @user.tweets << @tweet
  redirect '/users/' + @user.id.to_s
end

get '/users/:id' do
  @user = User.find(params[:id])
  haml :profile
end

get '/news_feed' do 
  @tweets = Tweet.all
  haml :news_feed
end


