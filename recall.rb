require 'sinatra'
require 'data_mapper'
require 'sinatra/flash'
require 'bundler/setup'

enable :sessions

SITE_TITLE = "Recall"
SITE_DESCRIPTION = "'cause you're too busy to remember"

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db")

class Note
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :complete, Boolean, :required => true, :default => false
  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  @notes = Note.all :order => :id.desc
  @title = 'All Notes'
  if @notes.empty?
    flash.now[:error] = 'No notes found. Add your first below.'
  end
  erb :home
end

post "/" do
  n = Note.new
  n.content = params[:content]
  n.created_at = Time.now
  n.updated_at = Time.now
  if n.save
    redirect '/', flash.next[:notice] = "Note created successfully."
  else
    redirect '/', flash.next[:error] = "Failed to save note."
  end
end

get "/rss.xml" do
  @notes = Note.all :order => :id.desc
  builder :rss
end

get "/:id" do
  @note = Note.get params[:id]
  @title = "Edit note #{params[:id]}"
  erb :edit
end

put '/:id' do
  n = Note.get params[:id]
  n.content = params[:content]
  n.complete = params[:complete] ? 1 : 0
  n.updated_at = Time.now
  if n.save
    redirect '/', flash.next[:notice] = "Note updated successfully."
  else
    redirect '/', flash.next[:error] = "Error updating note."
  end
  redirect '/'
end

get '/:id/delete' do
  @note = Note.get params[:id]
  @title = "Confirm deletion of note ##{params[:id]}"
  erb :delete
end

delete '/:id' do
  n = Note.get params[:id]
  if n.destroy
    redirect '/', flash.next[:notice] = "Note deleted successfully."
  else
    redirect "/", flash.next[:error] = "Error deleting note."
  end
  redirect '/'
end

get "/:id/complete" do
  n = Note.get params[:id]
  n.complete = n.complete ? 0 : 1
  n.updated_at = Time.now
  if n.save
    redirect '/', flash.next[:notice] = "Note marked as complete."
  else
    redirect '/', flash.next[:error] = "Error marking note as complete."
  end
end