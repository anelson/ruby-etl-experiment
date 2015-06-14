require 'test_helper'

require 'transformation'
require 'source_step'

class EtlStepTest < EtlTestCase
	class GenerateNumbersStep < SourceStep
		def before_run
			@incoming = (0..100).to_a
		end

		def process_row(row)
			row
		end
	end

	class SumNumbersStep < SinkStep
		def before_run
			self.shared_sum = 0
		end

		def process_row(row)
			self.shared_sum = self.shared_sum + row
		end

		def sum
			self.shared_sum
		end
	end

	def setup
		Rodimus.configure do |config|
			config.logger = Rails.logger
			config.benchmarking = true
		end
	end

	test "shared data is passed between transform and running steps" do
		t = Transformation.new

		t.shared_data['foo'] = 'lame'

		t.add_step GenerateNumbersStep.new
		t.add_step SumNumbersStep.new

		t.run

		assert_equal (0..100).to_a.inject{|sum,x| sum+x}, t.steps[1].sum
	end
end
