module ApplicationHelper
  # Return a title on a per-page basis.
  def title
    base_title = "tiviti"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
   def logo
		image_tag("tiviti-logo.jpg", :alt => "tiviti", :class => "round")
   end
  
end
