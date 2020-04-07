class ChangeSettingValueFieldToText < ActiveRecord::Migration[5.2]
	def up
    change_column :site_settings, :value, :text
  end

  def down
    change_column :site_settings, :value, :integer
  end
end
