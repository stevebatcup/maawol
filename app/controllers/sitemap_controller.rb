class SitemapController < ApplicationController
	def index
		@courses = Course.all
		@stores = Store.all
		@pages = ContentManagement::Page.all
	end
end