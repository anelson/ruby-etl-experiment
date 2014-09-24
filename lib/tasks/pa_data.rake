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

	desc "Drop all loaded raw PA building detail data"
	task :clean_raw_building_details => :environment do 
		clean_raw_data RawBuildingDetail
	end

	desc "Load raw building details data"
	task :load_raw_building_details, [:csv_file_path] => [:environment, :clean_raw_building_details] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicBuildingDetailsExtract.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawBuildingDetail, csv_file_path
	end

	desc "Drop all loaded raw PA building data"
	task :clean_raw_buildings => :environment do 
		clean_raw_data RawBuilding
	end

	desc "Load raw building data"
	task :load_raw_buildings, [:csv_file_path] => [:environment, :clean_raw_buildings] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicBuildingExtract.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawBuilding, csv_file_path
	end

	desc "Drop all loaded raw PA building traverse data"
	task :clean_raw_building_traverses => :environment do 
		clean_raw_data RawBuildingTraverse
	end

	desc "Load raw building traverse data"
	task :load_raw_building_traverses, [:csv_file_path] => [:environment, :clean_raw_building_traverses] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicBuildingTraverse.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawBuildingTraverse, csv_file_path
	end

	desc "Drop all loaded raw PA extra feature data"
	task :clean_raw_extra_features => :environment do 
		clean_raw_data RawExtraFeature
	end

	desc "Load raw extra feature data"
	task :load_raw_extra_features, [:csv_file_path] => [:environment, :clean_raw_extra_features] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicExtraFeaturesExtract.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawExtraFeature, csv_file_path
	end

	desc "Drop all loaded raw PA land data"
	task :clean_raw_land => :environment do 
		clean_raw_data RawLand
	end

	desc "Load raw land data"
	task :load_raw_land, [:csv_file_path] => [:environment, :clean_raw_land] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicLandExtract.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawLand, csv_file_path
	end

	desc "Drop all loaded raw PA legal data"
	task :clean_raw_legal => :environment do 
		clean_raw_data RawLegal
	end

	desc "Load raw legal data"
	task :load_raw_legal, [:csv_file_path] => [:environment, :clean_raw_legal] do |t, args|
		args.with_defaults(:csv_file_path => "rawdata/PublicLegalExtract.csv")

		csv_file_path = args[:csv_file_path]

		load_raw_data RawLegal, csv_file_path
	end

	desc "Load all raw PA data"
	task :load_all => [:environment, :load_raw_parcels, :load_raw_sales, :load_raw_building_details, :load_raw_buildings, :load_raw_building_traverses, :load_raw_extra_features, :load_raw_land, :load_raw_legal] do |t|
	end

	desc "Process previously loaded raw PA data"
	task :process_data => :environment do
		progress = ProgressBar.create(:title => "Processing raw PA data", :starting_at => 0, :total => RawParcel.count, :format => "%t: Records: %c Elapsed %a Records/second: %r  %b")
		
		parcels = []

		begin
			RawParcel.all.find_each(:batch_size => ROWS_PER_BATCH).each do |p|
				parcels << p

				if parcels.length == ROWS_PER_BATCH
					parcels.each do |raw_parcel|
						raw_parcel.upsert_to_parcel
						progress.increment
					end

					parcels.clear
				end
			end

			#Load any more left in the array
			parcels.each do |raw_parcel|
				raw_parcel.upsert_to_parcel
					progress.increment
			end
		rescue Exception => e
			progress.stop
			raise e
		end

		progress.finish
	end

	desc "Play with rodimus"
	task :rod_test => :environment do
		Rodimus.configure do |config|
			config.logger = Rails.logger
			config.benchmarking = true
		end

		t = Rodimus::Transformation.new

		csv_step = CsvInput.new("rawdata/mini_parcel.csv")
		output_step = DummyOutput.new

		t.steps << csv_step
		t.steps << output_step
		
		t.run

		puts "Muni code counts: #{output_step.muni_record_counts}"
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

		puts "Loading data from #{csv_file_path}"

		progress = ProgressBar.create(:title => klass.name, :starting_at => 0, :total => nil, :format => "%t: Records: %c Elapsed %a Records/second: %r  %b")
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
			fixedrow = row.strip()[1..-2].split("\",\"")

			Rails.logger.info "Fixed malformed row [[#{row}]] as [[#{fixedrow}]]"

			fixedrow
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
