require "administrate/field/base"

class AudioFileField < Administrate::Field::Base
  def to_s
    data
  end

  def file
  	data.file if data
  end
end