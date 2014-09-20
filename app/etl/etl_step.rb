require 'rodimus'
require 'msgpack'

# Base class for all of our ETL steps.  Adds several nice capabilities on top of Rodimus, like
# serializing objects between steps instead of using strings
class EtlStep < Rodimus::Step
	# Called by Rodimus Transformation (and hopefully nowhere else) to attach the output of a step
	# to the pipe connected to the input of another step.  Assume it's an IO object that operates in 
	# terms of strings.  Wrap it with a MessagePack packer so we can write objects to it, and 
	# have them serialized properly
	def outgoing=(pipe)
		# Pipe must be in binary mode so it doens't try to do any character re-encoding on the binary stream
		pipe.binmode

		# Now wrap the pipe in a packer
		@outgoing = MessagePack::Packer.new(pipe)
	end

	# Called by Rodimus Transformation (and hopefully nowhere else) to attach the input of a step
	# to the pipe connected to the output of another step.  Assume it's an IO object that operates in 
	# terms of strings.  Wrap it with a MessagePack packer so we can write objects to it, and 
	# have them serialized properly
	#
	# NB: If you are writing a step that sources external data, make sure you set '@incoming' directly,
	# and don't go through this accessor, or you're gonna have a bad time
	def incoming=(pipe)
		pipe.binmode

		@incoming = MessagePack::Unpacker.new(pipe)
	end

	# Assuming the output is actually an object instead of just a string,
	# write it to the outgoing pipe (which we know is actually a MessagePack packer)
	# and flush so it gets written to the underlying IO object immediately.  Note that
	# this call to flush doesn't necessarily defeat any buffering by the underlying IO
	# object
	def handle_output(row)
		@outgoing.write(row).flush
	end

	def close_descriptors
		#Call the base class to close either incoming or outgoing descriptors of the more
		#conventional kind (like IO).  For some reason the Packer/Unpacker do not have a close
		#method to close the underlying stream.  So we must do it ourselves
		super()

		[incoming, outgoing].reject(&:nil?).each do |descriptor|
        descriptor.buffer.io.close if descriptor.respond_to?(:buffer) && descriptor.buffer.io.respond_to?(:close)
    end
	end
end
