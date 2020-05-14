class Comp < User
	default_scope	-> { where(status: [:complimentary]) }
end