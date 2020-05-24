json.status @status
json.error @error if @error
json.full_error @full_error if @full_error
json.full_error @backtrace if @backtrace
json.paypalRedirect @paypal_redirect if @paypal_redirect