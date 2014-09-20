require 'rodimus'
require 'csv'
require 'msgpack'

# Generic CSV input class; well, not exactly generic, since it handles the idiosyncracies of Miami-Dade County
# property appraiser CSV files
#
# Generates output rows in the form of a hash with names from the column labels and values from each row of the CSV file
class CsvInput < Rodimus::Step
	attr_accessor :csv_file_path 

	def initialize(csv_file_path)
		super()

		@csv_file_path = csv_file_path

		#Blank values should be treated as NULL
		CSV::Converters[:blank_to_nil] = lambda do |field|
		  field && field.empty? ? nil : field
		end
	end

	def before_run_open_csv
		Rails.logger.info "opening CSV file #{csv_file_path}"

		@incoming = File.open(csv_file_path, 'r')
		@outgoing.binmode
		@outgoing = MessagePack::Packer.new(@outgoing)

		#Skip the first 4 lines which are stupid county garbage
		4.times { @incoming.readline }

		#Read the headers on the 5th line
		# Convert the headers to snake_case, except the header '1/2 Baths', which isn't valid as an attribute so
		# translate it
		@headers = CSV.parse(@incoming.readline)[0].map {|c| c == "1/2 Baths" ? "HalfBaths" : c}.map {|c| c.underscore }
	end

	def process_row(row)
		# row will be a line from the input file.  Parse it into an array of elements using the CSV parser, then
		# munge that into a hash using the header row for the column names
		Hash[@headers.zip(try_parse_csv(row))]
	end

	def handle_output(row)
		@outgoing.write(row).flush
	end

	private

	def try_parse_csv(row)
		# Try to parse with Ruby's CSV library, but sometimes we'll get a row like this:
		#   "0142060661970","01","ANDREA DE GAETANO","","","ANDREA DE GAETANO","","LAGO DELL"OLGLATA 15","ISOLA 69H1 00123 ROME","","","ITALY","325 S BISCAYNE BLVD 1419","325","S","BISCAYNE","","BLVD","","1419","Miami","33131-2306","0407","6401","1227.00","0.00","0.0000","2","2.00","0","1","0","1","2005","2005","0101","2014","0","0","0","364890","0","0","0","0","0","0","0","0","0","0","271330","0","271330","0","271330","0","271330","0","364890","2013","0","0","0","269090","0","0","0","0","0","0","0","0","0","0","246664","0","246664","0","246664","0","246664","0","269090","2012","0","0","0","224240","0","0","0","0","0","0","0","0","0","0","224240","0","224240","0","224240","0","224240","0","224240"
		#
		# where one of the columns contains a quote.  In this case we fall back to a parsing logic based on Ruby split
		begin
			CSV.parse(row, :converters => [:blank_to_nil])[0]
		rescue CSV::MalformedCSVError => e
			# Chop leading and trailing quotes, then split the rest
			fixedrow = row.strip()[1..-2].split("\",\"")

			Rails.logger.info "Fixed malformed row [[#{row}]] as [[#{fixedrow}]]"

			fixedrow
		end
	end
end
