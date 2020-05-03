class AddTokenToAudioFiles < ActiveRecord::Migration[6.0]
  def change
		add_column	:audio_files, :token, :string
  end
end
