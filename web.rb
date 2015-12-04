require 'sinatra'
require 'rack/tracker'

use Rack::Tracker do
  handler :google_analytics, { tracker: ENV['GOOGLE_TRACKING_ID'] }
end
set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + '/public'
get '/' do
  erb :index
end
