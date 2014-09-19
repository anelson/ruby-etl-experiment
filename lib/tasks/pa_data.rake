require 'csv'
require 'ruby-progressbar'
require 'upsert'

namespace :padata do
	desc "Drop all loaded raw PA data"
	task :clean => :environment do 
		puts "Deleting all raw parcel records"
		RawParcel.delete_all
	end

	desc "Load raw parcel data"
	task :load_raw_parcels, [:csv_file_path] => [:environment] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicParcelExtract.csv")

		CSV::Converters[:blank_to_nil] = lambda do |field|
		  field && field.empty? ? nil : field
		end

		csv_file_path = args[:csv_file_path]

		puts "Loading parcel data from #{csv_file_path}"

		progress = ProgressBar.create(:title => "Raw parcels", :starting_at => 0, :total => nil, :format => "%t: Records: %c Elapsed: %a Records/second: %r  %b")
		count = 0

		begin
			File.open(csv_file_path, 'r') do |f|
				headers = nil

				upsert = Upsert.new(RawParcel.connection, RawParcel.table_name) 
				f.each_with_index do |row, i| 
					begin
						# The first 4 lines are comments; skip them
						next if i < 4

						# The last row is a 'footer', delimited with 'F'
						next if row.starts_with? "F "

						if i == 4 
							# Convert the headers to Ruby symbols, except the header '1/2 Baths', which isn't valid as an attribute so
							# translate it
							headers = CSV.parse(row)[0].map {|c| c == "1/2 Baths" ? :HalfBaths : c.to_sym}
						else
							data = Hash[headers.zip(try_parse_csv(row))]


							#upsert.row({:Folio => data[:Folio]}, data)
							split_and_upsert(upsert, :Folio, data[:Folio], data)

							# parcel = RawParcel.find_or_initialize_by(Folio: data[:Folio])

							# data.each do |key, value|
							# 	parcel[key] = value
							# end

							# parcel.save
							progress.increment
							count += 1
						end

					rescue Exception => e
						progress.log "#{csv_file_path}:#{i+1}: #{e.inspect}"
						progress.log "Row contents: "
						progress.log "  #{row}"
						raise e
					end
				end
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

	MAX_UPSERT_VALUES = 99
	def split_and_upsert(upsert, id_column, id_value, data)
		#PG can't upsert with with 100 or more columns due to a limitation on the # of params to a function.
		#If needed, split it up
		head_data = data.first(MAX_UPSERT_VALUES)
		tail_data = data.drop(MAX_UPSERT_VALUES)

		upsert.row({id_column => id_value}, head_data)

		if !tail_data.empty?
			split_and_upsert(upsert, id_column, id_value, tail_data)
		end
	end

end
