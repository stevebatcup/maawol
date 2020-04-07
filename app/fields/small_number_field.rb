require "administrate/field/base"

class SmallNumberField < Administrate::Field::Base
  def to_s
    data
  end

  def min
  	@options[:min]
  end

  def max
  	@options[:max]
  end

  def step
  	@options[:step] ||= 1
  end

  def show_percentage
  	@options[:show_percentage] ||= false
  end
end