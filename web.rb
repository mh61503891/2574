require 'sinatra'
require 'rack-google-analytics'

use Rack::GoogleAnalytics, tracker: ENV['GOOGLE_TRACKING_ID']
set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__) + '/public'
get '/' do
  erb :index
end
