#Mixin to include in an ETL step when its outgoing stream is expected to contain msgpack-serialized objects
module MsgpackOutput
	include MsgpackStep

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

	# Assuming the output is actually an object instead of just a string,
	# write it to the outgoing pipe (which we know is actually a MessagePack packer)
	# and flush so it gets written to the underlying IO object immediately.  Note that
	# this call to flush doesn't necessarily defeat any buffering by the underlying IO
	# object
	def handle_output(row)
		@outgoing.write(row).flush unless @outgoing == nil || row == nil
	end
end
