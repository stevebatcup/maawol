class ContactMailer < MaawolMailer
	def contact(submission)
		merge_vars = {
		  "NAME" => submission.name,
		  "EMAIL" => submission.email,
		  "MESSAGE" => submission.message
		}
		if submission.subject.present?
		  merge_vars["SUBJECT"] = submission.subject
		end
		subject = "New 'contact us' form submission"
		body = mandrill_template('contact-us', merge_vars)
		send_admin_mail(subject, body)
	end

	def stuck(submission)
		merge_vars = {
		  "NAME" => submission.name,
		  "EMAIL" => submission.email,
		  "ANSWERS" => build_answers(submission),
		  "SUBJECT" => submission.subject
		}
		subject = "Someone on the site is not sure what to work on!"
		body = mandrill_template('stuck', merge_vars)
		send_admin_mail(subject, body)
	end

private
	def build_answers(submission)
		text = ""
		submission.message_as_hash.each do |question, answer|
			text << "#{question}<br /><strong>#{answer}</strong><br /><br />"
		end
		text
	end
end