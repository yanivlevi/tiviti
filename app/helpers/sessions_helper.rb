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
  
  	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end
	
	    def remember_token
	      cookies.signed[:remember_token] || [nil, nil]
	    end
	
end
