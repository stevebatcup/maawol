class AddExpiresAtToDownloadablePermissions < ActiveRecord::Migration[5.2]
  def change
    add_column :downloadable_permissions, :expires_at, :datetime, after: :token
  end
end
