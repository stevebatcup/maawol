class PrivacyPolicyController < MaawolController
	def show
		@school_name = SiteSetting.school_name
		@school_email = Maawol::Config.site_owner_email
		@school_url = Maawol::Config.site_host
		@school_owner = "#{Maawol::Config.site_owner_fname} #{Maawol::Config.site_owner_lname}"
	end
end
