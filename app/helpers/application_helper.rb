module ApplicationHelper
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
end
