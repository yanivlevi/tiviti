class UsersController < ApplicationController
  
  # define the show function to display a user on the web page using show.html.erb (temp)
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @title = "Sign up"
  end

end
