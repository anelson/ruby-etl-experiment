# Reads lines from a text file, passing them to the next step one row at a time.
class TextFileInputStep < SourceStep
	attr_accessor :file_path 

	def initialize(file_path, skip_header_lines: 0, file_options: { })
		super()

		@file_path = file_path
		@skip_header_lines = skip_header_lines
		@file_options = file_options
	end

	def before_run_open_file
		Rails.logger.info "opening text file #{file_path}"

		@incoming = File.open(file_path, mode: 'r', opt: @file_options)

		@line = 1

		#Optionally skip leading lines
		@skip_header_lines.times do
			@incoming.readline
			@line += 1
		end

		@bytes_read = @incoming.pos
		@total_bytes = @incoming.size
		@output_row = { 'line' => 0, 'content' => nil }
	end

	def process_row(row)
		@output_row['line'] = @line
		@output_row['content'] = row

		@line += 1
		@bytes_read = @incoming.pos

		@output_row
	end
end
