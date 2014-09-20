require 'test_helper'

require 'msgpack'

class TestStep < EtlStep
	attr_accessor :input_rows, :output_rows

	def initialize
		super

		@input_rows = []
		@output_rows = []
	end

	def process_row(row)
		output = {"processed" => true, "row" => row}
		@input_rows << row
		output
	end

	def handle_output(row)
		super

		@output_rows << row
	end
end

class EtlStepTest < EtlTestCase
	def setup
		@incoming_to_test_step, @outgoing_to_test_step = IO.pipe
		@outgoing_to_test_step.binmode

		@incoming_from_test_step, @outgoing_from_test_step = IO.pipe
		@outgoing_from_test_step.binmode

		@step = TestStep.new
		@step.incoming = @incoming_to_test_step
		@step.outgoing = @outgoing_from_test_step

		@input_packer = MessagePack::Packer.new(@outgoing_to_test_step)
		@output_unpacker = MessagePack::Unpacker.new(@incoming_from_test_step)

		@row = {"foo" => "bar", "baz" => 2}
	end

	def teardown
		[@outgoing_to_test_step, @incoming_to_test_step, @outgoing_from_test_step, @incoming_from_test_step].reject(&:nil?).each { |p| p.close unless p.closed? }
	end

	test "processes input in MessagePack format" do
		@input_packer.write(@row).flush
		@outgoing_to_test_step.close

		@step.run

		assert_equal 1, @step.output_rows.count
		assert_equal Hash["processed" => true, "row" => @row ], @step.output_rows.first
	end

	test "produces output in MessagePack format" do
		@input_packer.write(@row).flush
		@outgoing_to_test_step.close

		@step.run

		result = @output_unpacker.read

		assert_equal Hash["processed" => true, "row" => @row ], result
	end
end
