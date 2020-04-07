class ListeningLab < ApplicationRecord
	has_and_belongs_to_many	:albums
	has_and_belongs_to_many	:lessons

	validates_presence_of :name

	def spotify_embed_url
		return nil if self.spotify_url.nil?
		if self.spotify_url.index("embed/playlist")
			self.spotify_url
		elsif insert_point = self.spotify_url.index("playlist")
			self.spotify_url.insert(insert_point, "embed/")
		else
			nil
		end
	end
end