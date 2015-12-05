require 'sinatra'
require 'rack/tracker'
require 'sass'
require 'coffee-script'
require 'tilt/erb'
require 'tilt/sass'
require 'tilt/coffee'
require 'sinatra/reloader' if development?

use Rack::Tracker do
  handler :google_analytics, tracker: ENV['GOOGLE_TRACKING_ID']
end
set :bind, '0.0.0.0'

get '/' do
  erb :index
end

get '/2574.js' do
  template = File.join(settings.views, '2574.coffee')
  locals = { mapbox_access_token: ENV['MAPBOX_ACCESS_TOKEN'] }
  coffee Tilt::StringTemplate.new(template).render(Object.new, locals)
end

get '/2574.css' do
  sass :'2574'
end
