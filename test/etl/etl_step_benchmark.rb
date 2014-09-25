require 'test_helper'

require 'rodimus'

class DevNull
	def close; nil; end
	def puts(x); nil; end
	def write(x); nil; end
	def binmode; nil; end
end

class DummyIOGenerator < DevNull
	def initialize(iterations, block)
		@iterations = iterations
		@block = block
	end

	def each
		@iterations.times do
			yield @block.call
		end
	end
end

class TestStringGenerator < DummyIOGenerator
	def initialize(iterations)
		super(iterations, lambda { "TEST STRING "})
	end
end

class TestObjectGenerator < DummyIOGenerator
	def initialize(iterations)
		super(iterations, lambda { { "foo" => bar, "baz" => 5 } })
	end
end

class SourceEtlStep < EtlStep
	def initialize(input)
		super()
		@incoming = input
	end
end

# A step that does some nominal processing on an object, returning a different object as a result
class TransformEtlStep < EtlStep
	def process_row(x) 
		{ :processed => true, :row => x}
	end
end

# A step that does nothing with the input it's given
class SinkEtlStep < EtlStep
	def handle_output(x); nil; end
end

class EtlStepBenchmark < EtlTestCase
	ITERATION_COUNT = 10000

	test "benchmark raw throughput assuming no I/O" do
		skip("too slow")
		Benchmark.bmbm do |bm|
			bm.report('EtlStep with object serialization') do
				t = Rodimus::Transformation.new

				source = SourceEtlStep.new(TestStringGenerator.new(ITERATION_COUNT))
				t.steps << source

				transform = TransformEtlStep.new
				t.steps << transform

				sink = SinkEtlStep.new
				t.steps << sink
				
				t.run
			end

			bm.report('Rodimus Steps with no serialization') do
				# Make a transform with three steps, the first one hooked up to an object generator,
				# the last one writing out to nothing, and the one in between just outputting the object it's given
				t = Rodimus::Transformation.new

				source = Rodimus::Step.new
				source.incoming = TestStringGenerator.new(ITERATION_COUNT)
				t.steps << source

				transform = Rodimus::Step.new
				t.steps << transform

				sink = Rodimus::Step.new
				sink.outgoing = DevNull.new
				t.steps << sink
				
				t.run
			end
		end

		# Required to avoid ActiveRecord::StatementInvalid: PG::ConnectionBad: PQconsumeInput() : ROLLBACK failures
		#
		# Rodimus forks the ruby process after a postgres database connection is established, and when the forked process ends,
		# it closes the connection.  This call forces this parent process to reconnect
		#ActiveRecord::Base.establish_connection
	end
end
