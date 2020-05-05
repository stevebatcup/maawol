class CreateTmpMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :tmp_media do |t|
      t.string :file_type
      t.string :media_file
      t.string :resource_class

      t.timestamps
    end
  end
end
