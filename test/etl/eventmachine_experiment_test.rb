require 'test_helper'

require 'eventmachine'

class EventMachineExperimentTest < EtlTestCase
	class PipeClient < EventMachine::FileWatch
		def initialize
			@count = 0
		end

		def count; @count; end

		def notify_readable
			@io.readlines.each do |line|
				assert_equal LINE, line.rstrip
				@count += 1
			end
		end

	  def unbind
	    puts "#{path} monitoring ceased"
	    EM.stop

	    assert_equal LINES, @count
	  end
	end

	MB = 1024.0 * 1024.0
	LINES = 800000
	LINE = %q{"0101000000020","01","16 SE 2ND STREET LLC","","","16 SE 2ND STREET LLC","","505 PARK AVE #18 FL","NEW YORK","NY","10022","USA","16 SE 2 ST","16","SE","2","","ST","","","Miami","33131-2103","2865","6401","0.00","60198.00","1.3820","0","0.00","0","0","0","0","0","0","0101","2014","15049500","0","6789","15056289","0","0","0","0","0","0","0","0","0","0","15056289","0","15056289","0","15056289","0","15056289","0","15056289","2013","5718810","0","6789","5725599","0","0","0","0","0","0","0","0","0","0","5725599","0","5725599","0","5725599","0","5725599","0","5725599","2012","5718810","0","8764","5727574","0","0","0","0","0","0","0","0","0","0","5727574","0","5727574","0","5727574","0","5727574","0","5727574"}
	SIZE = LINE.length * LINES

	def setup
		ActiveRecord::Base.connection_pool.disconnect!
	end

	test "how fast is Ruby native IO reads" do
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

			puts "Ruby native file IO: Read #{size / MB} MB/#{count} lines in #{time.real}.  #{size / MB / time.real} MB/sec  #{count / time.real} lines/sec"
		end
	end

	test "how fast can we write to /dev/null" do
		time = Benchmark.measure do 
			write = File.open('/dev/null', 'w')
			write.binmode
		
			count = 0
			LINES.times do 
				write.write LINE
				count += 1
			end
			write.close
		end

		puts "Write to /dev/null: Read #{SIZE / MB} MB/#{LINES} lines in #{time.real}.  #{SIZE / MB / time.real} MB/sec  #{LINES / time.real} lines/sec"
	end

	test "are pipes within the same process slow" do
		read, write = IO.pipe

		time = Benchmark.measure do 
			count = 0
			LINES.times do 
				write.puts LINE
				assert_equal LINE, read.gets.rstrip
				count += 1
			end
			write.close

			assert read.eof?
			read.close
		end

		puts "Pipes in process: Read #{SIZE / MB} MB/#{LINES} lines in #{time.real}.  #{SIZE / MB / time.real} MB/sec  #{LINES / time.real} lines/sec"
	end

	test "are pipes to a child forked process slow" do
		read, write = IO.pipe

		time = Benchmark.measure do 
			child_id = fork {
				count = 0
				write.close

				read.each do |line|
					assert_equal LINE, line.rstrip

					count += 1

					if count % 1000 == 0 
						#puts "from child: #{count} rows processed"
					end
				end

				read.close

				assert_equal LINES, count
			}

			count = 0
			read.close
			LINES.times do 
				write.puts LINE
				count += 1
				if count % 1000 == 0 
					#puts "from parent: #{count} rows processed"
				end
			end
			write.close

			Process.waitall
		end

		puts "Pipes: Read #{SIZE / MB} MB/#{LINES} lines in #{time.real}.  #{SIZE / MB / time.real} MB/sec  #{LINES / time.real} lines/sec"
	end

	test "can we speed things up with binary transfers" do
		read, write = IO.pipe
		read.binmode
		write.binmode

		time = Benchmark.measure do 
			child_id = fork {
				bytes = 0
				write.close
				buffer = String.new()

				while !read.eof? do
					data = read.readpartial(4096)
					bytes += data.length
				end

				read.close

				assert_equal SIZE, bytes
			}

			count = 0
			read.close
			LINES.times do 
				write.write LINE
				count += 1
				if count % 1000 == 0 
					#puts "from parent: #{count} rows processed"
				end
			end
			write.close

			Process.waitall
		end

		puts "Binary pipes: Read #{SIZE / MB} MB/#{LINES} lines in #{time.real}.  #{SIZE / MB / time.real} MB/sec  #{LINES / time.real} lines/sec"
	end

	test "Can we use eventmachine with pipes to make it faster?" do
		skip("doesn't work yet; reader is broken")
		read, write = IO.pipe

		time = Benchmark.measure do 
			child_id = fork {
				count = 0
				write.close

				EM.run do

				end

				fdmon = EM.watch(read, PipeClient)
				fdmon.notify_readable = true

				read.close
			}

			count = 0
			read.close
			LINES.times do 
				write.puts LINE
				count += 1
				if count % 1000 == 0 
					#puts "from parent: #{count} rows processed"
				end
			end
			write.close

			assert_equal LINES, count

			Process.waitall
		end

		puts "Pipes: Read #{SIZE / MB} MB/#{LINES} lines in #{time.real}.  #{SIZE / MB / time.real} MB/sec  #{LINES / time.real} lines/sec"
	end
end
