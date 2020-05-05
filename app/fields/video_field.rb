require "administrate/field/base"

class VideoField < Administrate::Field::Base
  def to_s
    data
  end

  def vimeo_data
  	resource.vimeo_data unless resource.vimeo_data.nil?
  end

  def url
  	resource.url unless resource.url.nil?
  end
end
