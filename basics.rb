# Learning about routes and params / Not part of the app

# require 'sinatra'
# 
# get '/' do
#   "Hello, World!"
# end
# 
# get '/about' do
#   'A little about me.'
# end
# 
# get '/hello/:name' do
#   params[:name]
# end
# 
# get "/testing/:first/:last" do
#   "Your name is #{params[:first].capitalize} #{params[:last].capitalize}."
# end
# 
# get "/more/*" do 
#   params[:splat]
# end
# 
# get "/form" do
#   erb :form
# end
# 
# post "/form" do
#   "You said #{params[:message]}"
# end
# 
# get "/secret" do
#   erb :secret
# end
# 
# post "/secret" do
#   params[:secret].reverse
# end
# 
# get "/decrypt/:secret" do
#   params[:secret].reverse
# end
# 
# not_found do
#   status 404
#   'not found'
# end
# 
# get "/jonnyc" do
#   erb :jon
# end


