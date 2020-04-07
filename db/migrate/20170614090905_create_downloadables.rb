class CreateDownloadables < ActiveRecord::Migration[5.0]
  def change
    create_table :downloadables do |t|
      t.string :name
      t.string :file

      t.timestamps
    end

    create_table :downloadables_lessons, id: false do |t|
      t.belongs_to :lesson, index: true
    	t.belongs_to :downloadable, index: true
    end
  end
end
