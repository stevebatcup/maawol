require "administrate/field/has_many"

class NestedStuckAnswerField < Administrate::Field::HasMany
  def to_s
    data
  end

  def object
  	data
  end
end