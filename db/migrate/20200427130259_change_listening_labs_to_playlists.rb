class ChangeListeningLabsToPlaylists < ActiveRecord::Migration[6.0]
  def change
  	drop_table	:albums
  	drop_table	:albums_listening_labs

  	rename_table :listening_labs, :playlists
  	add_column	:playlists, :apple_music_url, :string
  	add_column	:playlists, :amazon_music_url, :string
  end
end
