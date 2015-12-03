require 'sinatra'

set :bind, '0.0.0.0'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
  erb :index
end

# get '/' do
#   send_file File.join(settings.public_folder, 'index.html')
# end
