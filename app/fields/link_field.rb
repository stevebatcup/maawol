require "administrate/field/base"

class LinkField < Administrate::Field::Base
  def to_s
    data
  end
end