base_url = Maawol::Config.site_host

xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9', 'xmlns:image' => 'http://www.google.com/schemas/sitemap-image/1.1', 'xmlns:video' => 'http://www.google.com/schemas/sitemap-video/1.1' do
	xml.url do
	  xml.loc base_url
	  xml.lastmod  Time.now.strftime("%Y-%m-%d")
	  xml.changefreq 'daily'
	  xml.priority 1.0
	end

	xml.url do
	  xml.loc "#{base_url}/about-us"
	  xml.lastmod  Time.now.strftime("%Y-%m-%d")
	  xml.changefreq 'monthly'
	  xml.priority 1.0
	end

	xml.url do
	  xml.loc "#{base_url}/contact-us"
	  xml.lastmod  Time.now.strftime("%Y-%m-%d")
	  xml.changefreq 'monthly'
	  xml.priority 1.0
	end

	xml.url do
	  xml.loc "#{base_url}/privacy-policy"
	  xml.lastmod  Time.now.strftime("%Y-%m-%d")
	  xml.changefreq 'monthly'
	  xml.priority 1.0
	end

	xml.url do
	  xml.loc "#{base_url}/terms-and-conditions"
	  xml.lastmod  Time.now.strftime("%Y-%m-%d")
	  xml.changefreq 'monthly'
	  xml.priority 1.0
	end

  @courses.each do |course|
	  xml.url do
	    xml.loc "#{base_url}#{course_by_slug_path(slug: course.slug)}"
	    xml.lastmod  course.updated_at.strftime("%Y-%m-%d")
	    xml.changefreq 'monthly'
	    xml.priority 0.9
	  end
  end

  @stores.each do |store|
	  xml.url do
	    xml.loc store.full_url
	    xml.lastmod  store.updated_at.strftime("%Y-%m-%d")
	    xml.changefreq 'monthly'
	    xml.priority 0.9
	  end
  end

  @pages.each do |page|
	  xml.url do
	    xml.loc "#{base_url}#{page.url}"
	    xml.lastmod  page.updated_at.strftime("%Y-%m-%d")
	    xml.changefreq 'monthly'
	    xml.priority 0.9
	  end
  end
end