require 'test_helper'

require 'eventmachine'

class EventMachineExperimentTest < EtlTestCase
	MB = 1024.0 * 1024.0
	test "is eventmachine even needed" do
		#path = get_test_data_file_path('parcel_test.csv')
		path = get_test_data_file_path('../../../rawdata/PublicParcelExtract.csv')

		File.open(path, 'r') do |file|
			size = File.size(file)
			count = 0
			time = Benchmark.measure do 
				file.each do |line|
					count += 1
				end
			end

			puts "Read #{size / MB} MB/#{count} lines in #{time.real}.  #{size / MB / time.real} MB/sec  #{count / time.real} lines/sec"
		end
	end
end
