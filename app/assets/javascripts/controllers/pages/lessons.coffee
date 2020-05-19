class Maawol.Lessons extends Maawol.Page

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
	  '$scope'
	  '$http'
	  '$element'
	  '$timeout'
	  '$compile'
	  'Lesson'
	  'Comment'
	]

	init: ->
		@getVars = @constructor.helpers.getUrlVars()
		if @isListingsPage()
			@scope.category = @element.data('category')
			@initListings()
			@getItems @bindScrollEvent
		else
			@videoHost = @element.data('video-host')
		@bindEvents()

	isListingsPage: =>
		@element.hasClass('list')

	initListings: =>
		@scope.moreToLoad = true
		@scope.page = 1
		@scope.lessons = []
		@scope.loaded = false
		@scope.totalLessons = 0

	bindEvents: =>
		super
		@bindSubscribeCalloutClick()
		@bindDesktopOnlyEvents() unless @isMobile()

		$('#post_comment', '.comment-form').on 'click', (e) =>
			e.preventDefault()
			@postComment()

		$(document).on 'click', 'a.reply', (e) =>
			e.preventDefault()
			$commentBox = $(e.currentTarget).closest('[data-comment-id]')
			$replyBox = $('#respond')
			$replyBox.find('a#cancel_reply').show()
			name = $commentBox.data('name')
			$replyBox.find('textarea').attr 'placeholder', "Reply to #{name}"
			$replyBox.addClass('replying').detach().insertAfter($commentBox)
			$('#post_comment', $replyBox).val @element.data('comment-text-reply')

		$('a#cancel_reply', '#respond').on 'click', (e) =>
			e.preventDefault()
			$replyBox = $('#respond')
			$replyBox.find('a#cancel_reply').hide()
			$replyBox.find('textarea').attr 'placeholder', 'Add your comment...'
			$replyBox.removeClass('replying').detach().appendTo('#comments_top')
			$('#post_comment', $replyBox).val @element.data('comment-text-add')


		$('#viewed', '#actions').on 'click', (e) =>
			$clicked = $(e.currentTarget)
			id = $clicked.parent().data('lesson-id')
			if $clicked.hasClass('disabled')
				@deleteJSON "/views/#{id}", =>
					$clicked.removeClass('disabled')
			else
				@postJSON '/views', { lesson_id: id }, =>
					$clicked.addClass('disabled')

		$('#watchlater', '#actions').on 'click', (e) =>
			$clicked = $(e.currentTarget)
			id = $clicked.parent().data('lesson-id')
			if $clicked.hasClass('disabled')
				@deleteJSON "/watch_laters/#{id}", =>
					$clicked.removeClass('disabled')
			else
				@postJSON '/watch_laters', { lesson_id: id }, =>
					$clicked.addClass('disabled')

		$('#favourite', '#actions').on 'click', (e) =>
			$clicked = $(e.currentTarget)
			id = $clicked.parent().data('lesson-id')
			if $clicked.hasClass('disabled')
				@deleteJSON "/favourites/#{id}", =>
					$clicked.removeClass('disabled')
			else
				@postJSON '/favourites', { lesson_id: id }, =>
					$clicked.addClass('disabled')

		$(document).on 'change', 'select[name=root_category]', (e) =>
			chosen = $(e.currentTarget).val()
			$targetSelect = $('select[name=category]')
			if chosen.length > 0
				$targetSelect.html('').show().attr('disabled', true).append $('<option>').val('').text('select...')
				$.getJSON "/categories?root=#{chosen}", (categories) =>
					$.each categories, (index, category) =>
						$option = $('<option>').val(category.id).text(category.name)
						$targetSelect.removeAttr('disabled').append $option
			else
				$targetSelect.hide()

	bindDesktopOnlyEvents: ->

	bindScrollEvent: ->
		$win = $(window)
		$win.on 'scroll', =>
			if @scope.moreToLoad is true
				scrollTop = $win.scrollTop()
				docHeight = @getDocumentHeight()
				footerHeight = $('footer.site-footer').outerHeight()
				lessonHeight = $('.lesson_result').first().outerHeight()
				if @scope.page is 1
					@pageScrollOffset = Math.round(@getDocumentHeight() * 0.2)
				else
					@pageScrollOffset = (footerHeight + (lessonHeight * 2))
				if (scrollTop + $win.height()) >= (docHeight - @pageScrollOffset)
					@scope.moreToLoad = false
					@getItems()

	chooseCategory: ($event, category) =>
		$event.preventDefault()
		if @scope.loaded
			@scope.category = category
			@initListings()
			@getItems()

	getItems: (callback=null) =>
		vars = {page: @scope.page, category: @scope.category}
		if $('[data-search]').length
			vars['search'] = $('[data-search]').data('search')
		if $('[data-tag]').length
			vars['tag'] = $('[data-tag]').data('tag')
		if $('[data-root-category]').length
			vars['root_category'] = $('[data-root-category]').data('root-category')
		timeoutDelay = if @scope.page is 1 then 1200 else 1
		@Lesson.query(vars).then (response) =>
			@timeout =>
				@scope.loaded = true
				@scope.totalLessons = response.total if @scope.page is 1
				angular.forEach response.items, (item) =>
					@scope.lessons.push item
				@scope.moreToLoad = @scope.totalLessons > @scope.lessons.length
				@scope.page += 1
				callback.call(@) if callback?
			, timeoutDelay
		, (response) =>
			@refreshPage() if response.status is 401

	postComment: =>
		$textArea = $('textarea#comment')
		$commentBox = $textArea.closest('li.comment').find('[data-comment-id]').first()
		if $textArea.val().length > 0
			new @Comment
				article_type: "Lesson"
				article_id: @element.data('lesson-id')
				body: $textArea.val()
				parent: if $commentBox.length then $commentBox.data('comment-id') else 0
			.create().then (comment) =>
				if comment.status is 'success'
					$li = $('<li class="comment">')
					$li.append Mustache.render($('#comment_template').html(), comment)
					if $commentBox.length
						$listItem = $commentBox.parent()
						$childList = $listItem.find('ul.children')
						$listItem.append $('<ul class="children">') if $childList.length is 0
						$childList = $listItem.find('ul.children')
						$childList.prepend $li
					else
						$('ul.comment-list').prepend $li
					$('textarea#comment').val('')
					$('a#cancel_reply', '.respond').click() if $('a#cancel_reply', '.respond').is(':visible')
					$('h2.title', '.respond').text @element.data('comment-text-new')
				else
					alert comment.message
		else
			alert @element.data('comment-blank')

Maawol.ControllerModule.controller('LessonsController', Maawol.Lessons)