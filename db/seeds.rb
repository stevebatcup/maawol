puts "### Seeding database for #{Maawol::Config.site_name} ###"

avatar_url = "https://maawol.s3.amazonaws.com/seeds/contact-mugshot.png"
favicon_url = "https://maawol.s3.amazonaws.com/seeds/favicon.png"
landscape_logo_url = "https://maawol.s3.amazonaws.com/seeds/landscape-blue-logo.png"
square_logo_url = "https://maawol.s3.amazonaws.com/seeds/square-blue-logo.png"
email_banner_url = "https://maawol.s3.amazonaws.com/seeds/email-banner.png"

puts "> Seeding skill levels...."
%w{ Beginner Intermediate Advanced }.each { |level| SkillLevel.find_or_create_by(name: level) }

puts "> Seeding dite settings...."
settings = [
	{ name: "Site name", value: "#{Maawol::Config.site_name}" },
	{ name: "Site easy name", value: "#{Maawol::Config.site_name}" },
	{ name: "Site blurb", value: "#{Maawol::Config.site_name} - lorem	ipsum doo dah day" },
	{ name: "Site byline", value: "#{Maawol::Config.site_name} - lorem ipsum doo dah day" },
	{ name: "Meta description", value: "Please enter your meta description, this will help your site's SEO ranking" },
	{ name: "Contact email address", value: Maawol.site_owner_email },
	{ name: "Google Analytics ID", value: "" },
	{ name: "Facebook page URL", value: "" },
	{ name: "Twitter username", value: "" },
	{ name: "Instagram username", value: "" },
	{ name: "YouTube channel ID", value: "" }
]
settings.each { |setting| SiteSetting.find_or_create_by(name: setting[:name], value: setting[:value]) }

puts "> Seeding CMS Pages...."
homepage =  ContentManagement::Page.find_or_create_by(title: "Homepage", slug: "")
privacy =  ContentManagement::Page.find_or_create_by(title: "Privacy Policy")
tandcs =  ContentManagement::Page.find_or_create_by(title: "Terms and Conditions")

puts "> Seeding CMS Blocks...."
lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
					tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
					quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
					consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
					cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
					proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
blocks = [{
  name: "bio",
  title: "About #{Maawol::Config.site_name}",
  content: "<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
				tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
				quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
				consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
				cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
				proident, sunt in culpa qui officia deserunt mollit anim id est laborum.<p>
				<a class=\"btn btn-success btn-large\" title=\"Drop me a line\" href=\"/contact\">Drop me a line</a></p>",
  is_editable: 1
},
{
  name: "home_register_options",
  title: "Register or subscribe",
  content: "<div class=\"row\">\r\n<div class=\"col-12 col-md-6 px-md-4 pb-4 pb-md-3 pt-md-3\">\r\n<h5>Subscribed Members:</h5>\r\n<ul>\r\n<li>$25/month</li>\r\n<li>Access to FULL Lesson Library and Courses</li>\r\n<li>Lesson Requests</li>\r\n<li>1-on-1 help</li>\r\n<li>Access to Exclusive Facebook Group</li>\r\n</ul>\r\n<a class=\"mt-3 mb-md-5 btn btn-success btn-large\" style=\"bottom: 0;\" href=\"../../../users/register/sign_up?remember=/subscribe\">Subscribe now</a></div>\r\n<div class=\"col-12 col-md-6 align-items-end px-md-4 pb-md-3 pt-md-3\">\r\n<h5>Registered Members:</h5>\r\n<ul>\r\n<li>FREE</li>\r\n<li>Access to Selected Video Lessons</li>\r\n<li>Access to Exclusive Facebook Group</li>\r\n<li>Access to Exclusive Offers</li>\r\n</ul>\r\n<a class=\"mt-3 mb-md-5 btn btn-info btn-large\" style=\"bottom: 0;\" href=\"/sign_up\">Register now</a></div>\r\n</div>",
  is_editable: 1
},
{
  name: "course_introduction",
  title: "",
  content: "<p>Feel like digging a little deeper into something? That&rsquo;s what this section is for. Each course is a multi-lesson exploration into some subjects that can&rsquo;t be summed up in a lesson or two.</p>\r\n<p>Take a course from start to finish, or just pop in and work on any of the lessons individually.</p>",
  is_editable: 1
},
{
  name: "Privacy policy",
  title: "Privacy Policy",
  content: "<p>Privacy policy stuff here</p><p>#{lorem}</p>",
  is_editable: 1
},
{
  name: "Terms and Conditions",
  title: "Terms and Conditions",
  content: "<p>Terms and Conditions stuff here</p><p>#{lorem}</p>",
  is_editable: 1
}]
blocks.each { |block| ContentManagement::ContentBlock.find_or_create_by(block) }

puts "> Seeding CMS Navbars...."
navbars_data = [
	{ slug: :signed_out, items: [
		{ name: "Welcome", url: "/", desktop: true, mobile: true },
		{ name: "Register for FREE", url: "#register", desktop: true, mobile: true },
		{ name: "Recent lessons", url: "#recent_lessons", desktop: true, mobile: true },
		{ name: "About", url: "#bio", desktop: true, mobile: true },
		{ name: "Get in touch", url: "#contact", desktop: true, mobile: true }
	]},
	{ slug: :signed_in, items: [
		{ name: "My dashboard", url: "/home", desktop: true, mobile: true },
		{ name: "Lessons", url: "/lessons", desktop: true, mobile: true },
		{ name: "Courses", url: "/courses", desktop: true, mobile: true },
		{ name: "Not sure what to work on?", url: "/stuck", desktop: true, mobile: true },
		{ name: "Contact", url: "/contact", desktop: true, mobile: true },
		{ name: "My account", url: "/settings", desktop: false, mobile: true }
	]},
	{ slug: :footer, items: [
		{ name: "Privacy policy", url: "/privacy-policy", desktop: true, mobile: true },
		{ name: "Terms & Conditions", url: "/terms-and-conditions", desktop: true, mobile: true },
		{ name: "Get in touch", url: "/contact", desktop: true, mobile: true }
	]}
]
navbars_data.each do |navbar_data|
	navbar = ContentManagement::Navbar.find_or_create_by(slug: navbar_data[:slug])
	item_names = navbar.navbar_items.map(&:name)
	navbar_data[:items].each_with_index do |item, index|
		unless item_names.include?(item[:name])
			item[:sort] = index.to_i+1
			navbar.navbar_items.build(item)
		end
	end
	navbar.save
end

puts "> Seeding Stuck Question and Answers...."
qandas_data = [
	{ question: "What are you looking for?", sort: 1, answers: [
		{ answer: "Something quick", sort: 1 },
		{ answer: "Something to sink my teeth into", sort: 2, }
	]},
	{ question: "Do you have time to work on something on the kit, or will you be mostly away from the kit?", sort: 2, answers: [
		{ answer: "On the kit", sort: 1 },
		{ answer: "Away from the kit", sort: 2, }
	]},
	{ question: "Do you want to work on something technique-related, or something more open and improvisational?", sort: 3, answers: [
		{ answer: "Technique", sort: 1 },
		{ answer: "Inspirational", sort: 2, }
	]},
	{ question: "Do you want help preparing for a specific gig, or something more open-ended?", sort: 4, answers: [
		{ answer: "Preparing for gig", sort: 1 },
		{ answer: "Open-ended", sort: 2, }
	]},
]
qandas_data.each do |qanda_data|
	question = StuckQuestion.find_or_create_by(question: qanda_data[:question])
	answer_texts = question.stuck_answers.map(&:answer)
	qanda_data[:answers].each_with_index do |answer, index|
		unless answer_texts.include?(answer[:answer])
			question.stuck_answers.build(answer)
		end
	end
	question.sort = qanda_data[:sort]
	question.save
end

puts "> Seeding Author...."
unless author = Author.find_by(name: "#{Maawol::Config.site_owner_fname} #{Maawol::Config.site_owner_lname}")
	author = Author.create({
		name: "#{Maawol::Config.site_owner_fname} #{Maawol::Config.site_owner_lname}",
		remote_avatar_url: avatar_url
	})
end

puts "> Seeding Default colors...."
colors_data = [
	{ name: "Main background", slug: "body_background", value: "#ffffff", default_value: "#ffffff" },
	{ name: "Main text color", slug: "main_text", value: "#3e464a", default_value: "#3e464a" },
	{ name: "Main link color", slug: "main_link", value: "#1679c5", default_value: "#1679c5" },
	{ name: "Headings color", slug: "headings", value: "#3e464a", default_value: "#3e464a" },
	{ name: "Meta info text color", slug: "meta_text", value: "#5b727d", default_value: "#5b727d" },
	{ name: "Desktop > Top bar", slug: "desktop_top_bar", value: "#f5f5f5", default_value: "#f5f5f5" },
	{ name: "Desktop > Navbar > Background", slug: "desktop_navbar", value: "#313241", default_value: "#313241" },
	{ name: "Desktop > Navbar > Text", slug: "desktop_navbar_text", value: "#ffffff", default_value: "#ffffff" },
	{ name: "Desktop > Navbar > Selected item", slug: "desktop_nav_selected_item", value: "#c13a3f", default_value: "#c13a3f" },
	{ name: "Desktop > Navbar > Item hover", slug: "desktop_nav_hover_item", value: "#ba7476", default_value: "#ba7476" },
	{ name: "Desktop > Footer > Background", slug: "desktop_footer_background", value: "#2a3a4a", default_value: "#2a3a4a" },
	{ name: "Desktop > Footer text", slug: "desktop_footer_text", value: "#b0bec5", default_value: "#b0bec5" },
	{ name: "Desktop > Account links (top right of page)", slug: "desktop_account_links", value: "#5c696f", default_value: "#5c696f" },
	{ name: "Mobile > Header & Navbar background", slug: "mobile_navbar", value: "#313241", default_value: "#313241" },
	{ name: "Mobile > Navbar > Selected item", slug: "mobile_nav_selected_item", value: "#c13a3f", default_value: "#c13a3f" },
	{ name: "Mobile > Navbar > Text", slug: "mobile_navbar_text", value: "#ffffff", default_value: "#ffffff" },
	{ name: "Mobile > Footer > Background", slug: "mobile_footer_background", value: "#2a3a4a", default_value: "#2a3a4a" },
	{ name: "Mobile > Footer > Text", slug: "mobile_footer_text", value: "#b0bec5", default_value: "#b0bec5" },
	{ name: "Footer > Copyright > Background", slug: "copyright_background", value: "#18222b", default_value: "#18222b" },
	{ name: "Footer > Copyright > Text", slug: "copyright_text", value: "#ffffff", default_value: "#ffffff" },
	{ name: "Section title", slug: "section_title", value: "#455a64", default_value: "#455a64" },
	{ name: "Section title highlight", slug: "section_title_highlight", value: "#bf2828", default_value: "#bf2828" },
	{ name: "Lesson listing box background", slug: "listing_box_background", value: "#f5f5f5", default_value: "#f5f5f5" },
	{ name: "Lesson listing box border", slug: "listing_box_border", value: "#e3e3e3", default_value: "#e3e3e3" },
	{ name: "Buttons > Viewed", slug: "buttons_viewed", value: "#3aaec1", default_value: "#3aaec1" },
	{ name: "Buttons > Watch later", slug: "buttons_watch_later", value: "#28bf4f", default_value: "#28bf4f" },
	{ name: "Buttons > Favourite", slug: "buttons_favourite", value: "#9f74ba", default_value: "#9f74ba" }
]
colors_data.each do |color_data|
	SiteColor.find_or_create_by(name: color_data[:name], slug: color_data[:slug], value: color_data[:value], default_value: color_data[:default_value])
end

puts "> Seeding Site Images...."
images_data = [
	{ name: "Landscape logo", slug: 'landscape_logo', remote_image_url: landscape_logo_url },
	{ name: "Square logo", slug: 'square_logo', remote_image_url: square_logo_url },
	{ name: "Contact mugshot", slug: 'contact', remote_image_url: avatar_url },
	{ name: "Email banner", slug: 'email_banner', remote_image_url: email_banner_url },
	{ name: "Favicon", slug: 'favicon', remote_image_url: favicon_url }
]
images_data.each do |image_data|
	unless SiteImage.find_by(name: image_data[:name])
		SiteImage.create(image_data)
	end
end

puts "> Seeding Admin User...."
unless User.find_by(email: Maawol.site_owner_email, is_admin: true)
	u = User.new({
		first_name: Maawol.site_owner_fname,
		last_name: Maawol.site_owner_lname,
		email: Maawol.site_owner_email,
		is_admin: true,
		author_id: author.id
	})
	u.password = "sonmi451"
	u.save
end

puts "> Seeding Categories...."
categories_data = [
	{ root_category: "Technique", secondary_categories: [
		{ name: "Co-ordination", description: "One of the biggest challenges to swing/latin, etc. is getting all those limbs to cooperate. Look here for exercise to help, mostly in a musical setting." },
		{ name: "Exercises", description: "If you want to get good you've got to eat your vegetables!" }
	]},
	{ root_category: "Vocabulary", secondary_categories: [
		{ name: "Comping", description: "So much of our sound comes from our approach to comping. Whether you think of it 'Complimenting' or 'Accompanying,' it's got lots of moving parts." },
		{ name: "Soloing", description: "Here you'll find soloing phrases, soling concepts, and general advice on everything from lengthy, open solos, to fills." }
	]},
	{ root_category: "Performace", secondary_categories: [
		{ name: "Gig preparation", description: "Philosophy on gigs, prep exercises, and general 'pre-game' stuff." },
		{ name: "Recording", description: "How to prepare for the moment they hit that record button!" }
	]},
]
categories_data.each do |category_data|
	root_category = RootCategory.find_or_create_by(name: category_data[:root_category])
	secondary_cat_texts = root_category.categories.map(&:name)
	category_data[:secondary_categories].each_with_index do |secondary_category, index|
		unless secondary_cat_texts.include?(secondary_category[:name])
			root_category.categories.build(secondary_category)
		end
	end
	root_category.save
end

puts "> Seeding Subscription options...."
sub_options = [
	{ days: 30,
		level:	1,
		status: 'active',
		price: 25.00,
		display_sort: 1,
		description: 'Standard monthly',
		name: 'Regular',
		custom: false,
		payment_system_plan: 'regular-2018'
	},
	{ days: 365,
		level:	2,
		status: 'active',
		price: 100.00,
		display_sort: 2,
		description: 'Christmas season special',
		tag: 'most-popular',
		name: '1 Year promotional',
		custom: false,
		payment_system_plan: 'yearly-promotional'
	}
]
sub_options.each do |sub_option|
	SubscriptionOption.find_or_create_by(sub_option)
end

puts "> Seeding Tags...."
tags = [
	'Theory',
 	'Comping',
	'Big band',
	'Orchestra',
	'Soloing',
	'Practicing',
	'Away from your instrument'
]
tags.each { |tag| Tag.find_or_create_by(name: tag, show_in_cloud: true) }

puts "# Seeding Downloadable file sample...."
unless Downloadable.find_by(name: "Sample downloadable PDF")
	Downloadable.create({
		name: "Sample downloadable PDF",
		remote_file_url: "http://www.africau.edu/images/default/sample.pdf",
		author_id: author.id
	})
end

puts "> Seeding Videos...."
videos_data = [
	{ name: 'Homepage sample video',
		url: 'https://vimeo.com/405177296',
		is_for_homepage: true,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https:\/\/vimeo.com\/","title":"homepage-sample","author_name":"Steve Batcup","author_url":"https:\/\/vimeo.com\/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src=\"https:\/\/player.vimeo.com\/video\/405177296?app_id=122963\" width=\"640\" height=\"358\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen title=\"homepage-sample\"><\/iframe>","width":640,"height":358,"duration":19,"description":"","thumbnail_url":"https:\/\/i.vimeocdn.com\/video\/875250161_640.webp","thumbnail_width":640,"thumbnail_height":358,"thumbnail_url_with_play_button":"https:\/\/i.vimeocdn.com\/filter\/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F875250161_640.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-07 16:12:26","video_id":405177296,"uri":"\/videos\/405177296"},
		vimeo_id:  '405177296',
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-homepage.png'
	},
	{ name: 'Sample video 1',
		url: 'https://vimeo.com/404939755',
		is_for_homepage: false,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https://vimeo.com/","title":"sample-1","author_name":"Steve Batcup","author_url":"https://vimeo.com/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src='https://player.vimeo.com/video/404939755?app_id=122963' width='426' height='238' frameborder='0' allow='autoplay; fullscreen' allowfullscreen title='sample-1'></iframe>","width":426,"height":238,"duration":25,"description":"","thumbnail_url":"https://i.vimeocdn.com/video/874949710_295x166.webp","thumbnail_width":295,"thumbnail_height":165,"thumbnail_url_with_play_button":"https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F874949710_295x166.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-07 04:44:57","video_id":404939755,"uri":"/videos/404939755"},
		vimeo_id:  '404939755',
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-1.png'
	},
	{ name: 'Sample video 2',
		url: 'https://vimeo.com/404939719',
		is_for_homepage: false,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https://vimeo.com/","title":"sample-2","author_name":"Steve Batcup","author_url":"https://vimeo.com/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src='https://player.vimeo.com/video/404939719?app_id=122963' width='426' height='238' frameborder='0' allow='autoplay; fullscreen' allowfullscreen title='sample-2'></iframe>","width":426,"height":238,"duration":20,"description":"","thumbnail_url":"https://i.vimeocdn.com/video/874949654_295x166.webp","thumbnail_width":295,"thumbnail_height":165,"thumbnail_url_with_play_button":"https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F874949654_295x166.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-07 04:44:48","video_id":404939719,"uri":"/videos/404939719"},
		vimeo_id:  '404939719',
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-2.png'
	},
	{ name: 'Sample video 3',
		url: 'https://vimeo.com/404939676',
		is_for_homepage: false,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https://vimeo.com/","title":"sample-3","author_name":"Steve Batcup","author_url":"https://vimeo.com/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src='https://player.vimeo.com/video/404939676?app_id=122963' width='426' height='238' frameborder='0' allow='autoplay; fullscreen' allowfullscreen title='sample-3'></iframe>","width":426,"height":238,"duration":21,"description":"","thumbnail_url":"https://i.vimeocdn.com/video/874949565_295x166.webp","thumbnail_width":295,"thumbnail_height":165,"thumbnail_url_with_play_button":"https://i.vimeocdn.com/filter/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F874949565_295x166.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-07 04:44:38","video_id":404939676,"uri":"/videos/404939676"},
		vimeo_id:  '404939676',
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-3.png'
	},
]
videos_data.each do |video_data|
	unless Video.find_by(name: video_data[:name])
		video_data[:status] = :uploaded
		v = Video.new(video_data)
		v.save(context: :seeding)
	end
end

puts "> Seeding Listening labs...."
labs_data = [
	{ name: "Big Band", spotify_url: "https://open.spotify.com/playlist/6YrkhXFSoo24wdaX680PXw" },
	{ name: "Ballads", spotify_url: "https://open.spotify.com/playlist/5G6gcY3qRlB8oFjpEfMIUe" },
	{ name: "ECM", spotify_url: "https://open.spotify.com/playlist/4KNkbxw74H0bIbf1Qm5nk5" }
]
labs_data.each { |lab_data| ListeningLab.find_or_create_by(lab_data) }

puts "> Seeding Lessons...."
long_lorem = "
<p>Do eiusmod tempor incididunt ut labore et dolore magna aliqua. Architecto beatae vitae dicta sunt explicabo. Eaque ipsa quae ab illo inventore veritatis et quasi. Do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
<p>Itaque earum rerum hic tenetur a sapiente delectus. Itaque earum rerum hic tenetur a sapiente delectus. Et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque. Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>

<h3>Laboris nisi ut aliquip ex ea commodo consequat.</h3>
<p>Facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Duis aute irure dolor in reprehenderit in voluptate velit. At vero eos et accusamus. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.</p>

<ul>
	<li>Fugiat quo voluptas nulla pariatur?</li>
	<li>Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.</li>
	<li>Fugiat quo voluptas nulla pariatur?</li>
</ul>

<p>Architecto beatae vitae dicta sunt explicabo. Ut enim ad minim veniam, quis nostrud exercitation ullamco. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit. Excepteur sint occaecat cupidatat non proident, sunt in culpa.</p>
<p>Eaque ipsa quae ab illo inventore veritatis et quasi. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sed ut perspiciatis unde omnis iste natus error sit voluptatem. Do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
"
tag_ids = Tag.all.map(&:id)
category_ids = Category.all.map(&:id)
video_ids = Video.where(is_for_homepage: false).all.map(&:id)
lab_ids = ListeningLab.all.map(&:id)
lessons_data = [
	{
		name: "Lesson sample",
		course_only: false,
		content: long_lorem,
		publish_date: 5.weeks.ago,
		is_free: true,
		comments_count: 0,
		author_id: author.id,
		video_ids: video_ids.sample(1),
		downloadable_ids: [],
		tag_ids: tag_ids.sample(2),
		category_ids: category_ids.sample(1),
		listening_lab_ids: lab_ids.sample(1)
	},
	{
		name: "Another lesson sample",
		course_only: false,
		content: long_lorem,
		publish_date: 4.weeks.ago,
		is_free: true,
		comments_count: 0,
		author_id: author.id,
		video_ids: video_ids.sample(1),
		downloadable_ids: Downloadable.first.id,
		tag_ids: tag_ids.sample(1),
		category_ids: category_ids.sample(2),
		listening_lab_ids: lab_ids.sample(1)
	},
	{
		name: "One more lesson sample",
		course_only: false,
		content: long_lorem,
		publish_date: 3.weeks.ago,
		is_free: true,
		comments_count: 0,
		author_id: author.id,
		video_ids: video_ids.sample(1),
		downloadable_ids: [],
		tag_ids: tag_ids.sample(2),
		category_ids: category_ids.sample(1),
		listening_lab_ids: lab_ids.sample(1)
	},
	{
		name: "Multiple video lesson sample",
		course_only: false,
		content: long_lorem,
		publish_date: 1.week.ago,
		is_free: true,
		comments_count: 0,
		author_id: author.id,
		video_ids: video_ids.sample(3),
		downloadable_ids: [],
		tag_ids: tag_ids.sample(2),
		category_ids: category_ids.sample(1),
		listening_lab_ids: lab_ids.sample(1)
	}
]
lessons_data.each do |lesson_data|
	unless Lesson.find_by(name: lesson_data[:name])
		l = Lesson.create(lessons_data)
	end
end


puts "> Seeding Courses...."
skill_level_ids = SkillLevel.all.map(&:id)
lesson_ids = Lesson.all.map(&:id)
courses_data = [
	{ name: 'Sample course',
		description: lorem,
		publish_date: 1.week.ago,
		remote_image_url: 'https://maawol.s3.amazonaws.com/seeds/sample-course-1.png',
		include_in_menu: false,
		author_id: author.id,
		skill_level_ids: skill_level_ids.sample(1),
		tag_ids: tag_ids.sample(2),
		teachings_attributes: [{lesson_id: lesson_ids.sample, sort: 1}, {lesson_id: lesson_ids.sample, sort: 2}]
	},
	{ name: 'Another sample course',
		description: lorem,
		publish_date: 2.days.ago,
		remote_image_url: 'https://maawol.s3.amazonaws.com/seeds/sample-course-2.png',
		include_in_menu: false,
		author_id: author.id,
		skill_level_ids: skill_level_ids.sample(2),
		tag_ids: tag_ids.sample(1),
		teachings_attributes: [{lesson_id: lesson_ids.sample, sort: 1}, {lesson_id: lesson_ids.sample, sort: 2}, {lesson_id: lesson_ids.sample, sort: 3}]
	}
]
courses_data.each do |course_data|
	unless Course.find_by(name: course_data[:name])
		Course.create(course_data)
	end
end

puts "> Seeding Sample store...."
Store.create({
	name: "Sample store",
	description: lorem,
	products_attributes: [
		{
			sort: 1,
			price: 2.50,
			productable: Downloadable.first,
			author_fee_split: 0
		},
		{
			sort: 2,
			price: 18.00,
			productable: Course.first,
			author_fee_split: 0
		}
	]
})