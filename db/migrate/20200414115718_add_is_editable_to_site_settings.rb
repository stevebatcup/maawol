class AddIsEditableToSiteSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :site_settings, :is_editable, :boolean, default: true
  end
end
