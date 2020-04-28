class AddAudioFilesToLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :audio_files_lessons, id: false do |t|
    	t.belongs_to :audio_file, index: true
      t.belongs_to :lesson, index: true
    end
  end
end
