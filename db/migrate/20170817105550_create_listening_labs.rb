class CreateListeningLabs < ActiveRecord::Migration[5.0]
  def change
    create_table :listening_labs do |t|
      t.string :name
      t.string :spotify_url

      t.timestamps
    end
  end
end
