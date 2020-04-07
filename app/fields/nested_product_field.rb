require "administrate/field/has_many"

class NestedProductField < Administrate::Field::HasMany
  def to_s
    data
  end

  def object
  	data
  end

  def selected_options
    selected = []
    data.each do |p|
      selected << "#{p.musician_id}_#{p.instrument_id}"
    end
    selected
  end
end