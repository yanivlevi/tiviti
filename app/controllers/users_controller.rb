class UsersController < ApplicationController
  
  	# prevent none-authenticated users from accessing edit & update functions
  	before_filter :authenticate, :only => [:index, :edit, :update]
  	# make sure users can only edit their own settings, not someone else's. If user try to go to users/2/edit they'll be redirected to root/home page 
  	before_filter :correct_user, :only => [:edit, :update]
  
  	# make sure attackers cannot access the delete user function. Only admin can get to it if signed in
  	before_filter :admin_user,   :only => :destroy
  
	# this function used to display all users in the DB in the index.html.erb page
	def index
		@title = "All users"
		@users = User.paginate(:page => params[:page])
	end
	
	# define the show function to display a user on the web page using show.html.erb (temp)
	def show
		@user = User.find(params[:id])
		@title = @user.name
	end
	  
	def new
		@user = User.new
		@title = "Sign up"
	end
	
	def create
	    @user = User.new(params[:user])
	    if @user.save
	    	flash[:success] = "Welcome to tiviti!"
	    	#redirect_to @user
	    	redirect_to signin_path
	    else
	      @title = "Sign up"
	      render 'new'
	    end
	end
	
	def edit
	    #@user = User.find(params[:id])
	    @title = "Edit user"
  	end
  	
  	def update
  		# don't need to set @user since correct_user is called every time (top) and already defines the @user variable
		#@user = User.find(params[:id])
	    if @user.update_attributes(params[:user])
	      flash[:success] = "Profile updated."
	      redirect_to @user
	    else
	      @title = "Edit user"
	      render 'edit'
	    end
	end
	 
	# correspond to the delete function for admin to delete a user (in index.html.erb page)
	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User destroyed."
	    redirect_to users_path
  	end
   
	private
	
		def authenticate
	    	deny_access unless signed_in?
	    end
    
	    def correct_user
	    	@user = User.find(params[:id])
	    	redirect_to(root_path) unless current_user?(@user)
	    end
	    
	    # local function to ensure only admin users can execute the delete/destroy function. If anyone
	    # other than admin try to access the destroy function, s/he'll be redirected to root path (home page)
	    def admin_user
    		redirect_to(root_path) unless current_user.admin?
    	end
    
  
end
