class RenameLessonsLabsJoinTable < ActiveRecord::Migration[6.0]
  def change
  	rename_table	:lessons_listening_labs, :lessons_playlists
  	rename_column	:lessons_playlists, :listening_lab_id, :playlist_id
  end
end
