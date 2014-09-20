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

		@row = {"a string" => "bar", "an int" => 2, "a float" => 1.0/3.0, "an array" => [1, 2, 3, "4", 5.0], "a hash" => { "x" => 1, "y" => 2, 3 => 4}}
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

	test "supports serializing all the necessary Ruby types" do
		# Exercise the serializing of some extra Ruby types that msgpack doesn't itself handle, and that EtlStep doesn't handle very well
		row = @row

		row["a decimal"] = BigDecimal(1.5, 10)
		row["a datetime"] = DateTime.now
		row["a date"] = Date.today
		row["a time"] = Time.now

		@input_packer.write(row).flush
		@outgoing_to_test_step.close

		@step.run

		result = @output_unpacker.read

		#Due to msgpack limitations, result will not match row exactly, because decimal is serialized as float
		assert_equal row["a decimal"], result["row"]["a decimal"]
		assert_equal row["a datetime"].to_s, result["row"]["a datetime"]
		assert_equal row["a date"].to_s, result["row"]["a date"]
		assert_equal row["a time"].to_s, result["row"]["a time"]
	end
end
