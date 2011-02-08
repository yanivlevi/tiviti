# this migration was created to enforce uniqueness of email address in the DB
# by adding an index on the email address field in the users table. 
# See section 6.21 in the tutorial
# In addition, adding the index on the email address field will help in the user lookup performace (see 6.22)

class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
  	
  	# add_index, built in ruby function, to users table on the email field
  	 add_index :users, :email, :unique => true  	 
  end

  def self.down
  end
end
