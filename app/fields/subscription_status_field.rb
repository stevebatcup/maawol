require "administrate/field/base"

class SubscriptionStatusField < Administrate::Field::Base
  def to_s
    data
  end
end