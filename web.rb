require 'sinatra'
require 'rack/tracker'
require 'coffee-script'
require 'sass'
require 'sinatra/reloader' if development?

use Rack::Tracker do
  handler :google_analytics, { tracker: ENV['GOOGLE_TRACKING_ID'] }
end
set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
  erb :index
end

get '/2574.js' do
  coffee :'2574'
end

get '/2574.css' do
  sass :'2574'
end
