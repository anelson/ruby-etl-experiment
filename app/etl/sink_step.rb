# Base class for steps that take input from another step, and output it to some external system like a database or a file
class SinkStep < EtlStep
	include MsgpackInput
end
