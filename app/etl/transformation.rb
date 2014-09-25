require 'drb'

require 'rodimus'
require 'thread_safe'

# Subclass of the Rodiumus transformation, with a lot of extra tooling to support our framework
class Transformation < Rodimus::Transformation
	class UndumpedSharedDataHash < ThreadSafe::Hash
		# Ensure Drb doesn't try to marshall this by value between processes.  I don't knwo for sure that it will
		# but i want to be extra careful
		include DRb::DRbUndumped
	end

	def initialize()
		super()

		@shared_data = UndumpedSharedDataHash.new
	end

	def add_step(step)
		step.transformation = self
		@steps << step
	end

	def before_run_aaa_close_connections
		# Make sure all activerecord connections are closed before we fork the child processes.  Otherwise the children will close them on shutdown
		# and we will still think they are open
		ActiveRecord::Base.connection_pool.disconnect!
	end
end
