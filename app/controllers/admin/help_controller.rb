module Admin
  class HelpController < Admin::ApplicationController
    def show
    	respond_to do |format|
	      format.html do
		      render "admin/help/#{I18n.locale}/#{params[:section]}", layout: false
		    end
	    end
    end
  end
end
