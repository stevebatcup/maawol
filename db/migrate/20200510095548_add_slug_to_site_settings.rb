class AddSlugToSiteSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :site_settings, :slug, :string

    SiteSetting.all.each do |setting|
    	setting.update(slug: setting.name.parameterize)
    end
  end
end
