require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"

require_relative "database_persistence"

configure do
  enable :sessions
  set :session_secret, 'notsosecret'
  set :erb, :escape_html => true
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "trail_database.rb"
end

before do
  @storage = DatabasePersistence.new(logger)
end

helpers do
  def find_prior_trail(current_idx)
    max_negative_idx = -1 * @storage.number_trails
    all_indices = (max_negative_idx..-1).to_a
    new_idx = current_idx - 1
    all_indices.include?(new_idx) ? new_idx : -1
  end

  def find_next_trail(current_idx)
    all_indices = (0..@storage.number_trails - 1).to_a
    new_idx = current_idx + 1
    all_indices.include?(new_idx) ? new_idx : 0 
  end
end

get "/" do
  redirect "/homepage"
end

get "/homepage" do
  erb :homepage
end

get "/trails/:index" do

  if session[:trail_sort_order]
    @column = session[:trail_sort_field]
    @order = session[:trail_sort_order]
    @sorted_trails = @storage.sort_trails(@column, @order)
    @trail = @sorted_trails[0]
    
    @index = 0
  else
    @index = params[:index].to_i

    @trails = @storage.all_trails
    @trail = @trails[@index]
  end

  erb :trail
end

post "/trails/sort" do
  @index = params[:index].to_i
  session[:trail_sort_order] = params[:sort_order]
  session[:trail_sort_field] = params[:sort_field]
  redirect "/trails/0"
end
