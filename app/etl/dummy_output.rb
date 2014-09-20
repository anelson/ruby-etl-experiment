require 'rodimus'
require 'msgpack'

# Just for experimentation.  Play around with handling hashes from the CSV input
class DummyOutput < Rodimus::Step
	attr_reader :muni_record_counts

	def before_run_init_counts
		Rails.logger.info "Init DummyOutput"

		@muni_record_counts = Hash.new(0)

		@incoming.binmode
		@incoming = MessagePack::Unpacker.new(@incoming)
	end

	# Overwrite the standard behavior, which is to pipe the transformed row to the output stream
	# 
	# In our case do nothing since we don't want any output
	def handle_output(transformed_row)
	end

	def process_row(row)
		#This is just a dumb sample.  We'll count how many records we have for each muni code
		@muni_record_counts[row["municipality"]] += 1
	end

	def after_run
		puts "Muni code counts: #{@muni_record_counts}"
	end
end