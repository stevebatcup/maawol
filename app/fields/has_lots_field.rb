require "administrate/field/base"

class HasLotsField < Administrate::Field::HasMany
  def to_s
    data
  end
end