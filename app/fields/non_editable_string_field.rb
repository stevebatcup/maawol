require "administrate/field/string"

class NonEditableStringField < Administrate::Field::String
  def to_s
    data
  end
end