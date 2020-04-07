class AddAuthorIdToDownloadables < ActiveRecord::Migration[5.2]
  def change
    add_column :downloadables, :author_id, :integer, after: :file, default: 1
  end
end
