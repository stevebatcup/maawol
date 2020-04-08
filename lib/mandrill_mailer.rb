require "mandrill"

module MandrillMailer
  MANDRILL_SERVICE_FOR_API_LOG = 'mandrill'

private

  def mandrill_api
    @mandrill_api ||= Mandrill::API.new(Maawol.mandrill_api_key)
  end

  def requires_interception?
    Rails.env.development?
  end

  def send_non_user_mail(to, subject, body)
    if requires_interception?
      to = Maawol.mail_interceptor_to
      subject = "#{subject} [originally for #{to}]"
    end
    data = { to: to, subject: subject, body: body, content_type: "text/html" }
    response = api.messages.send data_for_mail(subject, body, to)
    log_mandrill_request(nil, "send_non_user_mail", data, response)
  end

  def send_mail(email_address, subject, body, user_name='', user_id=nil, tags=[])
    if requires_interception?
      to = Maawol.mail_interceptor_to
      subject = "#{subject} [for #{email_address}]"
    else
      to = email_override.nil? ? email_address : email_override
    end
    data = data_for_mail(subject, body, to, user_name, tags)
    response = mandrill_api.messages.send data
    log_mandrill_request(user_id, "send_mail", data, response) unless user_id.nil?
  end

  def send_admin_mail(subject, body)
    data = { to: Maawol.mail_admin_to, subject: subject, body: body, content_type: "text/html" }
    response = mail(**data)
    log_mandrill_request(0, "send_admin_mail", data, response)
  end

  def data_for_mail(subject, body, to, user_name, tags=[])
    data = {
      subject: subject, html: body,
      from_email: Maawol.mail_from, from_name: Maawol.site_name,
      to: [{email: to, name: user_name, type: 'to'}],
      headers: {'Reply-To': Maawol.mail_reply_to},
      merge: true
    }
    data[:tags] = tags if tags.any?
    data
  end

  def mandrill_template(template_name, attributes)
    merge_vars = attributes.map do |key, value|
      { name: key, content: value }
    end
    mandrill_api.templates.render(template_name, [], merge_vars)["html"]
  end

  def log_mandrill_request(user_id, method, request_data, response)
    response = response.is_a?(Mail::Message) ? {status: 'success'} : nil
    ApiLog.request(
      user_id: user_id,
      service: MANDRILL_SERVICE_FOR_API_LOG,
      request_method: method,
      request_data: request_data,
      response: response,
    )
  end
end