class LinkAuthorToUser < ActiveRecord::Migration[6.0]
  def change
  	add_column	:users, :author_id, :integer
  end
end
