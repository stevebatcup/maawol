require "administrate/field/base"

class DownloadableField < Administrate::Field::Base
  def to_s
    data
  end

  def file
  	data.file if data
  end
end