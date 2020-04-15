(function($){

	"use strict";

	var VideoStories = {

    // Bootstrap Carousels
    carousel: function() {
    	$('.carousel.slide').carousel({
    		cycle: true
    	});
    },

    matchHeight: function() {
    	$('article.post.type-post, .widget_instagram_feed img').matchHeight({
    		property: 'min-height'
    	});
    }
	};


	$(document).ready(function() {
		"use strict";

		// Background Img
		$(".background-bg").css('background-image', function () {
			var bg = ('url(' + $(this).data("image-src") + ')');
			return bg;
		});

		$('.section-title, aside .widget-title').each(function() {
			var word = $(this).html();
			var index = word.indexOf(' ');
			if(index == -1) {
				index = word.length;
			}
			$(this).html('<span class="first-word">' + word.substring(0, index) + '</span>' + word.substring(index, word.length));
		});

		VideoStories.carousel();
		VideoStories.matchHeight();
	});


	jQuery(window).on('scroll', function () {

		'use strict';

		if (jQuery(this).scrollTop() > 100) {
			jQuery('#scroll-to-top').fadeIn('slow');
		} else {
			jQuery('#scroll-to-top').fadeOut('slow');
		}

	});

	jQuery('#scroll-to-top').on("click", function() {
		'use strict';

		jQuery("html,body").animate({ scrollTop: 0 }, 1500);
		return false;
	});
})(jQuery);