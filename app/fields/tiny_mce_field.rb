require "administrate/field/base"

class TinyMceField < Administrate::Field::Base
  def to_s
    data
  end
end