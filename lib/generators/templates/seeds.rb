puts "### Seeding database for #{Maawol::Config.site_name} ###"

avatar_url = "https://maawol.s3.amazonaws.com/seeds/contact-mugshot.png"
favicon_url = "https://maawol.s3.amazonaws.com/seeds/favicon.png"
landscape_logo_url = "https://maawol.s3.amazonaws.com/seeds/landscape-blue-logo.png"
square_logo_url = "https://maawol.s3.amazonaws.com/seeds/square-blue-logo.png"
email_banner_url = "https://maawol.s3.amazonaws.com/seeds/email-banner.png"
admin_user_password = ENV['DEFAULT_ADMIN_PASSWORD']

puts "> Seeding Skill levels...."
%w{ Beginner Intermediate Advanced }.each { |level| SkillLevel.find_or_create_by(name: level) }

puts "> Seeding Site settings...."
settings_data = [
	{ name: "Site name", value: "#{Maawol::Config.site_name}", is_editable: true },
	{ name: "Site easy name", value: "#{Maawol::Config.site_name}", is_editable: true },
	{ name: "Site blurb", value: "#{Maawol::Config.site_name} - lorem	ipsum doo dah day", is_editable: true },
	{ name: "Site byline", value: "#{Maawol::Config.site_name} - lorem ipsum doo dah day", is_editable: true },
	{ name: "Theme", value: "light-blue", is_editable: true },
	{ name: "Monthly subscription price", value: "25.00", is_editable: true },
	{ name: "Meta description", value: "Please enter your meta description, this will help your site's SEO ranking", is_editable: true },
	{ name: "Contact email address", value: Maawol::Config.site_owner_email, is_editable: true },
	{ name: "Facebook page URL", value: "https://www.facebook.com/#{Maawol::Config.site_slug}", is_editable: true },
	{ name: "Twitter username", value: "#{Maawol::Config.site_slug}", is_editable: true },
	{ name: "Instagram username", value: "#{Maawol::Config.site_slug}", is_editable: true },
	{ name: "YouTube channel ID", value: "123456rty", is_editable: true },
	{ name: "Google Analytics ID", value: "", is_editable: true },
	{ name: "Owner profit split percentage", value: "80", is_editable: false },
	{ name: "Receives new-registration admin email", value: "yes", is_editable: false },
	{ name: "Receives new-subscription admin email", value: "yes", is_editable: false },
	{ name: "Receives subscription-cancelled admin email", value: "yes", is_editable: false },
	{ name: "Receives failed-payment admin email", value: "yes", is_editable: false },
	{ name: "Comp Account Limit", value: 25, is_editable: false },
]
settings_data.each do |setting_data|
	SiteSetting.find_or_create_by(name: setting_data[:name]) do |setting|
		setting.value = setting_data[:value]
		setting.is_editable = setting_data[:is_editable]
		setting.save
	end
end

puts "> Seeding CMS Blocks for page introductions...."
lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
					tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
					quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
					consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
					cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
					proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
blocks = [
	{
	  name: "Homepage introduction",
	  title: "#{Maawol::Config.site_name}",
		content: "<p>#{lorem}</p><p class='mb-4'>#{lorem}</p>",
	  is_editable: 1,
	  is_deletable: 0
	},
	{
	  name: "Courses introduction",
	  title: "",
	  content: "<p>Feel like digging a little deeper into something? That&rsquo;s what this section is for. Each course is a multi-lesson exploration into some subjects that can&rsquo;t be summed up in a lesson or two.</p>\r\n<p>Take a course from start to finish, or just pop in and work on any of the lessons individually.</p>",
	  is_editable: 1,
	  is_deletable: 0
	},
	{
	  name: "Lesson request introduction",
	  title: "",
	  content: "<p>As part of your subscription you can request a lesson from us.</p>",
	  is_editable: 1,
	  is_deletable: 0
	},
	{
	  name: "Contact page introduction",
	  title: "",
	  content: "<p>Have a question for us? Fill in the form below.</p>",
	  is_editable: 1,
	  is_deletable: 0
	}
]
blocks.each { |block| ContentManagement::ContentBlock.find_or_create_by(block) }

puts "> Creating About Us page...."
about_us_block_data = 	{
	  name: "About Us page main content",
	  title: "About Us",
	  content: "<p>Lots of information here about #{Maawol::Config.site_name}.</p><p>#{lorem}</p>",
	  is_editable: 1,
	  is_deletable: 0
}
about_us_block = ContentManagement::ContentBlock.find_or_create_by(about_us_block_data)
unless ContentManagement::Page.find_by(slug: "about-us")
	ContentManagement::Page.create({
		title: "About Us",
		slug: "about-us",
		sections_attributes: [{ sort: 1, content_block_id: about_us_block.id }],
		is_editable: 0
	})
end

puts "> Seeding CMS Navbars...."
navbars_data = [
	{ slug: :signed_out, items: [
		{ name: "Welcome", url: "/", desktop: true, mobile: true },
		{ name: "About Us", url: "/about-us", desktop: true, mobile: true },
		{ name: "Register for FREE", url: "/sign_up", desktop: true, mobile: true },
		{ name: "Get in touch", url: "/contact", desktop: true, mobile: true }
	]},
	{ slug: :signed_in, items: [
		{ name: "Home", url: "/lessons", desktop: true, mobile: true },
		{ name: "Courses", url: "/courses", desktop: true, mobile: true },
		{ name: "My lessons", url: "/dashboard", desktop: true, mobile: true },
		{ name: "Request a lesson", url: "/lesson-request", desktop: true, mobile: true },
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
	{ question: "Do you have time to work on something on your instrument, or will you be mostly away from your instrument?", sort: 2, answers: [
		{ answer: "On your instrument", sort: 1 },
		{ answer: "Away from your instrument", sort: 2, }
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
author_name = "#{Maawol::Config.site_owner_fname} #{Maawol::Config.site_owner_lname}"
unless author = Author.find_by(name: author_name)
	author = Author.create({
		name: author_name,
		remote_avatar_url: avatar_url,
		is_main: true
	})
end

puts "> Seeding Site Images...."
images_data = [
	{ name: "Landscape logo", slug: 'landscape-logo', remote_image_url: landscape_logo_url },
	{ name: "Square logo", slug: 'square-logo', remote_image_url: square_logo_url },
	{ name: "Contact mugshot", slug: 'contact', remote_image_url: avatar_url },
	{ name: "Email banner", slug: 'email-banner', remote_image_url: email_banner_url },
	{ name: "Favicon", slug: 'favicon', remote_image_url: favicon_url }
]
images_data.each do |image_data|
	unless SiteImage.find_by(name: image_data[:name])
		SiteImage.create(image_data)
	end
end

puts "> Seeding Admin User...."
unless User.find_by(email: Maawol::Config.site_owner_email, is_admin: true)
	u = User.new({
		first_name: Maawol::Config.site_owner_fname,
		last_name: Maawol::Config.site_owner_lname,
		email: Maawol::Config.site_owner_email,
		is_admin: true,
		author_id: author.id
	})
	u.password = admin_user_password
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
	{ root_category: "Performance", secondary_categories: [
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
	{
		days: 30,
		level:	1,
		status: 'active',
		price: 25.00,
		display_sort: 1,
		description: '1 month',
		name: 'Regular 1 month',
		custom: false,
		tag: nil,
		payment_system_plan: 'monthly'
	}
]
sub_options.each do |sub_option|
	unless SubscriptionOption.find_by(level: sub_option[:level])
		SubscriptionOption.create(sub_option)
	end
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

puts "> Seeding Downloadable file sample...."
sample_downloadable_name = "Sample downloadable PDF"
unless downloadable_file = Downloadable.find_by(name: sample_downloadable_name)
	downloadable_file = Downloadable.create({
		name: sample_downloadable_name,
		remote_image_url: "https://maawol.s3.amazonaws.com/seeds/sample-downloadable-image.png",
		remote_file_url: "https://maawol.s3.amazonaws.com/seeds/sample-downloadable-pdf.pdf",
		author_id: author.id
	})
end

puts "> Seeding Videos...."
videos_data = [
	{
		name: 'Homepage sample video',
		url: 'https://vimeo.com/407902224',
		is_for_homepage: true,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https:\/\/vimeo.com\/","title":"Homepage","author_name":"Steve Batcup","author_url":"https:\/\/vimeo.com\/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src=\"https:\/\/player.vimeo.com\/video\/407902224?app_id=122963\" width=\"426\" height=\"240\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen title=\"Homepage\"><\/iframe>","width":426,"height":240,"duration":20,"description":"","thumbnail_url":"https:\/\/i.vimeocdn.com\/video\/878651551_295x166.webp","thumbnail_width":295,"thumbnail_height":166,"thumbnail_url_with_play_button":"https:\/\/i.vimeocdn.com\/filter\/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F878651551_295x166.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-15 04:19:28","video_id":407902224,"uri":"\/videos\/407902224"},
		vimeo_id:  '407902224',
		duration_in_seconds: 20
	},
	{
		name: 'Sample video 1',
		url: 'https://vimeo.com/407902352',
		is_for_homepage: false,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https:\/\/vimeo.com\/","title":"Sample Video 1","author_name":"Steve Batcup","author_url":"https:\/\/vimeo.com\/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src=\"https:\/\/player.vimeo.com\/video\/407902352?app_id=122963\" width=\"426\" height=\"240\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen title=\"Sample Video 1\"><\/iframe>","width":426,"height":240,"duration":20,"description":"","thumbnail_url":"https:\/\/i.vimeocdn.com\/video\/878651864_295x166.webp","thumbnail_width":295,"thumbnail_height":166,"thumbnail_url_with_play_button":"https:\/\/i.vimeocdn.com\/filter\/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F878651864_295x166.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-15 04:20:06","video_id":407902352,"uri":"\/videos\/407902352"},
		vimeo_id:  '407902352',
		duration_in_seconds: 20
	},
	{
		name: 'Sample video 2',
		url: 'https://vimeo.com/407902261',
		is_for_homepage: false,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https:\/\/vimeo.com\/","title":"Sample Video 2","author_name":"Steve Batcup","author_url":"https:\/\/vimeo.com\/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src=\"https:\/\/player.vimeo.com\/video\/407902261?app_id=122963\" width=\"426\" height=\"240\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen title=\"Sample Video 2\"><\/iframe>","width":426,"height":240,"duration":20,"description":"","thumbnail_url":"https:\/\/i.vimeocdn.com\/video\/878651558_295x166.webp","thumbnail_width":295,"thumbnail_height":166,"thumbnail_url_with_play_button":"https:\/\/i.vimeocdn.com\/filter\/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F878651558_295x166.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-15 04:19:40","video_id":407902261,"uri":"\/videos\/407902261"},
		vimeo_id:  '407902261',
		duration_in_seconds: 20
	},
	{
		name: 'Sample video 3',
		url: 'https://vimeo.com/407902320',
		is_for_homepage: false,
		vimeo_data: {"type":"video","version":"1.0","provider_name":"Vimeo","provider_url":"https:\/\/vimeo.com\/","title":"Sample Video 3","author_name":"Steve Batcup","author_url":"https:\/\/vimeo.com\/user65939366","is_plus":"1","account_type":"plus","html":"<iframe src=\"https:\/\/player.vimeo.com\/video\/407902320?app_id=122963\" width=\"426\" height=\"240\" frameborder=\"0\" allow=\"autoplay; fullscreen\" allowfullscreen title=\"Sample Video 3\"><\/iframe>","width":426,"height":240,"duration":20,"description":"","thumbnail_url":"https:\/\/i.vimeocdn.com\/video\/878651697_295x166.webp","thumbnail_width":295,"thumbnail_height":166,"thumbnail_url_with_play_button":"https:\/\/i.vimeocdn.com\/filter\/overlay?src0=https%3A%2F%2Fi.vimeocdn.com%2Fvideo%2F878651697_295x166.webp&src1=http%3A%2F%2Ff.vimeocdn.com%2Fp%2Fimages%2Fcrawler_play.png","upload_date":"2020-04-15 04:19:57","video_id":407902320,"uri":"\/videos\/407902320"},
		vimeo_id:  '407902320',
		duration_in_seconds: 20
	},
]
videos_data.each do |video_data|
	unless Video.find_by(name: video_data[:name])
		video_data[:status] = :uploaded
		v = Video.new(video_data)
		v.save(context: :seeding)
	end
end

puts "> Seeding Playlists...."
playlists_data = [
	{ name: "Big Band", spotify_url: "https://open.spotify.com/playlist/6YrkhXFSoo24wdaX680PXw" },
	{ name: "Ballads", spotify_url: "https://open.spotify.com/playlist/5G6gcY3qRlB8oFjpEfMIUe" },
	{ name: "ECM", spotify_url: "https://open.spotify.com/playlist/4KNkbxw74H0bIbf1Qm5nk5" }
]
playlists_data.each { |playlist_data| Playlist.find_or_create_by(playlist_data) }

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
playlist_ids = Playlist.all.map(&:id)
lessons_data = [
	{
		name: "Lesson sample",
		course_only: false,
		content: long_lorem,
		publish_date: 5.weeks.ago,
		is_free: true,
		comments_count: 0,
		author_id: author.id,
		video_ids: video_ids[0],
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-1.png',
		downloadable_ids: [],
		tag_ids: tag_ids.sample(2),
		category_ids: category_ids.sample(1),
		playlist_ids: playlist_ids.sample(1)
	},
	{
		name: "Another lesson sample",
		course_only: false,
		content: long_lorem,
		publish_date: 4.weeks.ago,
		is_free: true,
		comments_count: 0,
		author_id: author.id,
		video_ids: video_ids[1],
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-2.png',
		downloadable_ids: downloadable_file.id,
		tag_ids: tag_ids.sample(1),
		category_ids: category_ids.sample(2),
		playlist_ids: playlist_ids.sample(1)
	},
	{
		name: "One more lesson sample",
		course_only: false,
		content: long_lorem,
		publish_date: 3.weeks.ago,
		is_free: false,
		comments_count: 0,
		author_id: author.id,
		video_ids: video_ids[2],
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-3.png',
		downloadable_ids: [],
		tag_ids: tag_ids.sample(2),
		category_ids: category_ids.sample(1),
		playlist_ids: playlist_ids.sample(1)
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
		remote_thumbnail_url: 'https://maawol.s3.amazonaws.com/seeds/thumbnail-sample-video-3.png',
		downloadable_ids: [],
		tag_ids: tag_ids.sample(2),
		category_ids: category_ids.sample(1),
		playlist_ids: playlist_ids.sample(1)
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
	{
		name: 'Sample course',
		description: lorem,
		publish_date: 1.week.ago,
		remote_image_url: 'https://maawol.s3.amazonaws.com/seeds/sample-course-1.png',
		include_in_menu: false,
		author_id: author.id,
		skill_level_ids: skill_level_ids.sample(1),
		tag_ids: tag_ids.sample(2),
		teachings_attributes: [{lesson_id: lesson_ids.sample, sort: 1}, {lesson_id: lesson_ids.sample, sort: 2}]
	},
	{
		name: 'Another sample course',
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
		course = Course.create(course_data)
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
			productable: downloadable_file,
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

puts "##### All Done. Yaay!"
puts "You can login to admin with:"
puts "email address:   #{Maawol::Config.site_owner_email}"
puts "and password:   #{admin_user_password}"