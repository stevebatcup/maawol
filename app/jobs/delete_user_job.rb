class DeleteUserJob < ApplicationJob
  queue_as :delete_user

  def perform(user)
  	user.purge
  end
end