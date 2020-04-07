require "administrate/field/base"

class MemberStatusField < Administrate::Field::Base
  def to_s
    data
  end
end