class Maawol.AdminPage extends Maawol.Page

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$element'
		'$http'
		'$timeout'
		'$sce'
	]

	init: ->
		@setDefaultHttpHeaders()
		@setCsrfTokenHeaders()
		@scope.settingHomepageVideo = false

	initSelectize: =>
		$(".field-unit--attachable-field select").selectize({});
		$(".field-unit--has-lots-field select").selectize({});

	initTinyMce: =>
		tinymce.init
			selector: "textarea.tinymce"
			plugins: "link image code"
			image_advtab: true
			image_uploadtab: true
			image_class_list: [
				{ title: 'Align Left', value: 'align_left' }
				{ title: 'Align Right', value: 'align_right' }
			]
			toolbar: [
				"h1 h2 h3 | bold italic underline strikethrough | link unlink image code"
				"alignleft aligncenter alignright alignjustify | undo redo | formatselect"
			]

	deleteUploadedFileError: (msg, $wrapper, resourceAttribute) =>
		@scope.fileUpload[resourceAttribute].deleteErrorMsg = msg
		$wrapper.find(".add_file").fadeIn('fast')

	initializeUploader: (resourceClass, resourceAttribute, fileType) =>
		@scope.fileUpload ||= {}
		@scope.fileUpload[resourceAttribute] = { tmpId: null, deleteErrorMsg: null }
		boxID = "#dropzone_#{resourceAttribute}"
		$wrapper = $(boxID)
		$displayElement = $("#{boxID} .player_target")
		previewNode = document.querySelector("#{boxID} .template")
		previewNode.id = ""
		previewTemplate = previewNode.parentNode.innerHTML
		previewNode.parentNode.removeChild(previewNode)

		fileDropzone = new Dropzone boxID,
			url: "/tmp-media?file_type=#{fileType}&resource_class=#{resourceClass}&resource_attribute=#{resourceAttribute}"
			maxFilesize: 25
			parallelUploads: 1
			previewTemplate: previewTemplate
			autoQueue: true
			previewsContainer: "#{boxID} .previews"
			clickable: "#{boxID} .add_file"

		fileDropzone.on "addedfile", (file) =>
			$('[name=commit]').attr('disabled', true)
			$('iframe', '.video_field').hide()
			$(".add_file", $wrapper).fadeOut('fast')
			$(document).on 'click', ".start_upload", (e) =>
				e.preventDefault()
				fileDropzone.enqueueFile(file)

		fileDropzone.on "complete", (file, response) =>
			$('[name=commit]').removeAttr('disabled')

		fileDropzone.on "success", (file, response) =>
			if response.status is 'success'
				@scope.fileUpload[resourceAttribute].tmpId = response.media.id
				$("input##{resourceClass}_#{resourceAttribute}_tmp_media_id").val(@scope.fileUpload[resourceAttribute].tmpId)
				if fileType is 'document'
					$displayElement.attr('href', response.media.url).fadeIn('fast')
				else if fileType is 'video'
					$displayElement.attr('src', response.media.url).fadeIn 'fast', =>
						videoDuration = Math.round(document.querySelector("#{boxID} .player_target").duration)
						$("input#video_duration_in_seconds").val videoDuration
				else
					$displayElement.attr('src', response.media.url).fadeIn('fast')
			else
				$('[data-dz-errormessage]', $wrapper).text response.error

		fileDropzone.on "removedfile", (file, response) =>
			if @scope.fileUpload[resourceAttribute].tmpId?
				@http.delete("/tmp-media/#{@scope.fileUpload[resourceAttribute].tmpId}").then (response) =>
					@timeout =>
						if response.data.status is 'success'
							@scope.fileUpload[resourceAttribute].tmpId = null
							$("input##{resourceClass}_#{resourceAttribute}_tmp_media_id").val ''
							if fileType is 'document'
								$displayElement.attr('href', '').fadeOut('fast')
							else
								$displayElement.attr('src', '').fadeOut('fast')
							$wrapper.find(".add_file").fadeIn('fast')
						else
							@deleteUploadedFileError(response.data.error, $wrapper, resourceAttribute)
					, 150
				, (error) =>
					@deleteUploadedFileError(error.statusText, $wrapper, resourceAttribute)
			else
				$wrapper.find(".add_file").fadeIn('fast')
