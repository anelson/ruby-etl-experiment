class RawParcel < ActiveRecord::Base
	def self.foo(folio)
		RawParcel.find_or_initialize_by(Folio: folio)
	end
end
