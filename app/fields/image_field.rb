require "administrate/field/base"

class ImageField < Administrate::Field::Base
  def to_s
    data
  end

  def hint
  	(@options[:hint] || "").html_safe
  end

  def small
  	data.small unless data.nil? || data.length == 0
  end

  def large
  	data.large unless data.nil? || data.length == 0
  end
end
