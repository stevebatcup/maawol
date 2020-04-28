require "administrate/field/base"

class AttachableField < Administrate::Field::HasMany
  def to_s
    data
  end

  def hint
    (@options[:hint] || "").html_safe
  end

  def associated_resource_options
  	options = super
  	out = []
    type = associated_class.to_s.downcase

  	options.each do |key, value|
      shortcode = key.parameterize.underscore
  		out << [key, value]
  	end
  	out
  end
end