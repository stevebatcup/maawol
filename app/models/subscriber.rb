class Subscriber < User
	default_scope	-> { where(status: [:paying]) }
end