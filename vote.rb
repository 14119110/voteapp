#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
#require 'sinatra/reloader'
require 'haml'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

enable :sessions

class Product < ActiveRecord::Base
  belongs_to :category
  has_one :vote
end

class Category < ActiveRecord::Base
  has_many :products
end

class Vote < ActiveRecord::Base
  belongs_to :product
end

get "/" do
  if (session[:voted].nil?)
    session[:voted] = ""
  end
  print "Vote count " + session[:voted].split(',').size.to_s + " product count " + Product.count.to_s + "\n"
  if (session[:voted].split(',').size >= Product.count) 
    @p = nil
  else 
    while (session[:voted].split(',').size < Product.count) do
      offset = rand(Product.count)
      @p = Product.first(:offset => offset)
      print "Product " + @p.id.to_s + "\n"
      if (not(session[:voted].split(',').member?(@p.id))) 
          break
      end
    end
    if (@p.vote.nil?) 
      v = Vote.new({:product_id => @p.id})
      v.save
    end
    print "Product is " + @p.shortdesc + " category is " + @p.category.name + "\n"
  end
  haml :index
end

get "/resetmyvotes" do
  session[:voted] = ""
  redirect('/')
end

get "/products" do
  @products = Product.all
  haml :showproducts
end

get "/products/new" do
  @categories = Category.all
  haml :addproduct
end

post "/products/new" do
  p = Product.new(params[:product])
  p.save
  v = Vote.new({:product_id => p.id})
  v.save
  redirect("/products")
end

delete "/products/:id" do
  Product.destroy(params[:id])
  redirect("/products")
end

get "/voteup/:id" do
  p = Product.find(params[:id])
  v = p.vote
  v.upvote = v.upvote + 1
  v.save
  if (session[:voted].nil?)
    session[:voted] = ""
  end
  session[:voted] += ',' + params[:id]
end 

get "/votedown/:id" do
  p = Product.find(params[:id])
  v = p.vote
  v.downvote = v.downvote + 1 
  v.save
  session[:voted] = session[:voted] + ',' + params[:id]
end

get "/resetvote/:id" do
  p = Product.find(params[:id])
  v = p.vote
  v.upvote = 0
  v.downvote = 0
  v.save
end

