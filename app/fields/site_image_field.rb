require "administrate/field/base"

class SiteImageField < Administrate::Field::Base
  def to_s
    data
  end

  def custom_version
  	case resource.slug.to_sym
  	when :favicon
  		tiny
  	when :contact
  		small_square
  	when :footer_logo, :main_logo, :dark_logo, :light_logo
  		small_landscape
  	else
  		small_square
  	end
  end

  def tiny
  	data.tiny unless data.nil? || data.length == 0
  end

  def small_square
  	data.small_square unless data.nil? || data.length == 0
  end

  def large_square
  	data.large_square unless data.nil? || data.length == 0
  end

  def small_landscape
  	data.small_landscape unless data.nil? || data.length == 0
  end

  def large_landscape
  	data.large_landscape unless data.nil? || data.length == 0
  end
end