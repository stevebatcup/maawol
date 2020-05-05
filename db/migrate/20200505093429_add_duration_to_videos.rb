class AddDurationToVideos < ActiveRecord::Migration[6.0]
  def change
  	add_column	:videos, :duration_in_seconds, :integer
  end
end
