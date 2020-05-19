module Admin
  class ResourceCountsController < Admin::ApplicationController
    def index
    	@counts = {
    		lessons: Lesson.count,
    		courses: Course.count,
    		tutors: Author.count,
    		rootCategories: RootCategory.count,
    		categories: Category.count,
    		tags: Tag.count,
    		skillLevels: SkillLevel.count,
    		videos: Video.count,
    		audioFiles: AudioFile.count,
    		downloadables: Downloadable.count,
    		playlists: Playlist.count,
    		students: User.active.count,
    		subscribers: User.active.where(status: :paying).count,
    		comps: User.active.where(status: :complimentary).count,
    		stores: Store.count,
    		storePayments: ProductPayment.count,
    		subscriptionPayments: UsersSubscriptionPayment.count,
    		incomeReports: IncomeReport.count,
        cmsPages: ::ContentManagement::Page.where(is_editable: true).count,
        cmsContentBlocks: ::ContentManagement::ContentBlock.where(is_editable: true).count,
        cmsImages: ::ContentManagement::Image.count,
      }
    end
  end
end
