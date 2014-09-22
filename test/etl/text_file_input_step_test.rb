require 'test_helper'

require 'msgpack'


class TextFileInputStepTest < EtlTestCase
	def setup
	end

	def teardown 
		# Required to avoid ActiveRecord::StatementInvalid: PG::ConnectionBad: PQconsumeInput() : ROLLBACK failures
		#
		# Rodimus forks the ruby process after a postgres database connection is established, and when the forked process ends,
		# it closes the connection.  This call forces this parent process to reconnect
		ActiveRecord::Base.establish_connection
	end

	def get_test_data_file_path(filename)
		File.dirname(__FILE__) + '/testdata/' + filename
	end

	test "reads zero rows from an empty text file" do
		step = TextFileInputStep.new(get_test_data_file_path('empty.txt'))

		output = run_source_step(step)

		assert_equal 0, output.length
	end

	test "reads all rows from a non-empty text file" do
		step = TextFileInputStep.new(get_test_data_file_path('three_rows.txt'))

		output = run_source_step(step)

		assert_equal 3, output.length
		assert_equal Hash[{ "line" => 1, "content" => "row 1\n" }], output[0]
		assert_equal Hash[{ "line" => 2, "content" => "row 2\n" }], output[1]
		assert_equal Hash[{ "line" => 3, "content" => "row 3\n" }], output[2]
	end

	test "skips header rows upon request" do
		step = TextFileInputStep.new(get_test_data_file_path('three_rows.txt'), skip_header_lines: 2)

		output = run_source_step(step)

		assert_equal 1, output.length
		assert_equal Hash[{ "line" => 3, "content" => "row 3\n" }], output[0]
	end
end
