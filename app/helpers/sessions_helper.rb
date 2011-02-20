module SessionsHelper
	
	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		self.current_user = user
	end
	
	# defining the current_user variable and asigning value to it
	def current_user=(user)
		@current_user = user
  	end
  
	# returning the current_user valiable (looks duplicated to the one above but both are enccesary)
	def current_user
		# set the @current_user instance variable to the user corresponding to the remember token, but only if @current_user is undefined
		@current_user ||= user_from_remember_token
  	end

	def signed_in?
		!current_user.nil?
	end
  
	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end
	
	# check is user is the current logged in user
	def current_user?(user)
    	user == current_user
  	end
  
	# used to make sure only authenticated users can access users update/edit functions
	def deny_access
		# store location for forwarding users after log in to their intended location
		store_location
    	redirect_to signin_path, :notice => "Please sign in to access this page."
  	end  
    
	# store location for forwarding users after log in to their intended location
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end
  
  	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end
	
	    def remember_token
	      cookies.signed[:remember_token] || [nil, nil]
	    end
	
		# user session cookie to store location for forwarding users after log in to their intended location
		def store_location
			session[:return_to] = request.fullpath
	    end
	
		# clear session cookie used to store location for forwarding users after log in to their intended location
	    def clear_return_to
			session[:return_to] = nil
	    end
end
