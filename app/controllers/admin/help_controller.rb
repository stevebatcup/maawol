module Admin
  class HelpController < Admin::ApplicationController
    def show
      tpl = render_to_string "admin/help/#{I18n.locale}/#{params[:section]}", format: :html
      render json: { content: tpl }
    end
  end
end
