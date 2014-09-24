require 'rodimus'
require 'msgpack'

# Base class for all of our ETL steps.  Adds several nice capabilities on top of Rodimus, like
# serializing objects between steps instead of using strings
class EtlStep < Rodimus::Step
	def initialize
		super()

		# It's VERY easy to forget to call the base class ctor, and when you do the step won't work at all
		# To avoid head scratching and throwing things, catch this common mistake and make it explicit
		@ctor_called = true
	end

	def notify(subject, event)
		if @ctor_called != true
			raise "There is a problem with #{self.class.name}!  It does not call the base class constructor so this step is not set up properly"
		end

		super
	end
end
