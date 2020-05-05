class Maawol.AdminPage extends Maawol.Page

	@register window.App
	@helpers = Maawol.FormHelpers

	@$inject: [
		'$scope'
		'$rootScope'
		'$http'
		'$element'
		'$timeout'
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

	deleteUploadedFileError: (msg) =>
		@scope.fileUpload.deleteErrorMsg = msg
		$(document).find(".add_file").fadeIn('fast')

	initializeUploader: (resource_class, file_type, displayElementId) =>
		@scope.fileUpload = { tmpId: null, deleteErrorMsg: null }
		$displayElement = $("##{displayElementId}")
		previewNode = document.querySelector("#template")
		previewNode.id = ""
		previewTemplate = previewNode.parentNode.innerHTML
		previewNode.parentNode.removeChild(previewNode)

		fileDropzone = new Dropzone document.body,
		  url: "/tmp-media?file_type=#{file_type}&resource_class=#{resource_class}"
		  thumbnailWidth: 80
		  thumbnailHeight: 80
		  parallelUploads: 1
		  previewTemplate: previewTemplate
		  autoQueue: true
		  previewsContainer: "#previews"
		  clickable: ".add_file"

		fileDropzone.on "addedfile", (file) =>
			$('[name=commit]').attr('disabled', true)
			$('iframe', '.video_field').hide()
			$(".add_file").find('span.action').text('Replace').end().fadeOut('fast')
			$(document).on 'click', ".start_upload", (e) =>
				e.preventDefault()
				fileDropzone.enqueueFile(file)

		fileDropzone.on "complete", (file, response) =>
			$('[name=commit]').removeAttr('disabled')

		fileDropzone.on "success", (file, response) =>
			if response.status is 'success'
				@scope.fileUpload.tmpId = response.media.id
				$("input##{resource_class}_tmp_media_id").val(@scope.fileUpload.tmpId)
				if file_type is 'document'
					$displayElement.attr('href', response.media.url).fadeIn('fast')
				else
					$displayElement.attr('src', response.media.url).fadeIn('fast')
			else
				$('[data-dz-errormessage]').text response.error

		fileDropzone.on "removedfile", (file, response) =>
			if @scope.fileUpload.tmpId?
				@http.delete("/tmp-media/#{@scope.fileUpload.tmpId}").then (response) =>
					@timeout =>
						if response.data.status is 'success'
							@scope.fileUpload.tmpId = null
							$("input##{resource_class}_tmp_media_id").val ''
							if file_type is 'document'
								$displayElement.attr('href', '').fadeOut('fast')
							else
								$displayElement.attr('src', '').fadeOut('fast')
							$(document).find(".add_file").find('span.action').text('Upload').end().fadeIn('fast')
						else
							@deleteUploadedFileError(response.data.error)
					, 350
				, (error) =>
					@deleteUploadedFileError(error.statusText)
			else
				$(document).find(".add_file").fadeIn('fast')
