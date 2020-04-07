class CreateDownloadablePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :downloadable_permissions do |t|
      t.integer :downloadable_id
      t.string :token
      t.integer :download_count

      t.timestamps
    end

    add_column	:downloadables, :token, :string, after: :file
  end
end
