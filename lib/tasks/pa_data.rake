require 'csv'
require 'ruby-progressbar'

namespace :padata do
	ROWS_PER_BATCH = 1024

	desc "Drop all loaded raw PA parcel data"
	task :clean_raw_parcels => :environment do 
		clean_raw_data RawParcel
	end

	desc "Load raw parcel data"
	task :load_raw_parcels, [:csv_file_path] => [:environment, :clean_raw_parcels] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicParcelExtract.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawParcel, csv_file_path
	end

	desc "Drop all loaded raw PA sales data"
	task :clean_raw_sales => :environment do 
		clean_raw_data RawSale
	end

	desc "Load raw sales data"
	task :load_raw_sales, [:csv_file_path] => [:environment, :clean_raw_sales] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicSalesExtractAllYears.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawSale, csv_file_path
	end

	# generic method to clean up one of the raw data tables
	def clean_raw_data(klass)
		puts "Deleting all #{klass.name} records"
		klass.delete_all
	end

	# generic method to load one of the raw data tables
	def load_raw_data(klass, csv_file_path)
		CSV::Converters[:blank_to_nil] = lambda do |field|
		  field && field.empty? ? nil : field
		end

		puts "Loading sales data from #{csv_file_path}"

		progress = ProgressBar.create(:title => klass.name, :starting_at => 0, :total => nil, :format => "%t: Records: %c Elapsed: %a Records/second: %r  %b")
		count = 0

		begin
			File.open(csv_file_path, 'r') do |f|
				headers = nil
				rows = []

				f.each_with_index do |row, i| 
					begin
						# The first 4 lines are comments and the 5th are column labels we don't use; skip them
						next if i < 5

						# The last row is a 'footer', delimited with 'F'
						next if row.starts_with? "F "

						# I know it's weird, we parse CSV only to generate CSV again, but it's to canonicalize the CSV into a form PG
						# can use, since some of the input data are, shall we say, sloppy.
						rows << try_parse_csv(row).to_csv

						if (rows.count == ROWS_PER_BATCH) 
							copy_rows klass.connection, klass.table_name, rows
						end

						progress.increment
						count += 1

					rescue Exception => e
						progress.log "#{csv_file_path}:#{i+1}: #{e.inspect}"
						progress.log "Rows contents: "
						progress.log "  #{rows}"
						raise e
					end
				end

				# Any remaining rows, write now
				copy_rows klass.connection, klass.table_name, rows
			end

			progress.total = count
		rescue Exception => e
			progress.stop
			raise e
		end

		progress.finish

		puts "Loaded #{count} records"
	end

	def try_parse_csv(row)
		# Try to parse with Ruby's CSV library, but sometimes we'll get a row like this:
		#   "0142060661970","01","ANDREA DE GAETANO","","","ANDREA DE GAETANO","","LAGO DELL"OLGLATA 15","ISOLA 69H1 00123 ROME","","","ITALY","325 S BISCAYNE BLVD 1419","325","S","BISCAYNE","","BLVD","","1419","Miami","33131-2306","0407","6401","1227.00","0.00","0.0000","2","2.00","0","1","0","1","2005","2005","0101","2014","0","0","0","364890","0","0","0","0","0","0","0","0","0","0","271330","0","271330","0","271330","0","271330","0","364890","2013","0","0","0","269090","0","0","0","0","0","0","0","0","0","0","246664","0","246664","0","246664","0","246664","0","269090","2012","0","0","0","224240","0","0","0","0","0","0","0","0","0","0","224240","0","224240","0","224240","0","224240","0","224240"
		#
		# where one of the columns contains a quote.  In this case we fall back to a parsing logic based on Ruby split
		begin
			CSV.parse(row, :converters => [:blank_to_nil])[0]
		rescue CSV::MalformedCSVError => e
			# Chop leading and trailing quotes, then split the rest
			row = row[1..-1]
			row.split("\",\"")
		end
	end

	def copy_rows(connection, table_name, rows)
		if (!rows.empty?)
			connection.raw_connection.copy_data("COPY #{table_name} FROM STDOUT CSV") do
				rows.each do |row|
					connection.raw_connection.put_copy_data row
				end
			end
			rows.clear
		end
	end
end
