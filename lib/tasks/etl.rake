Rails::TestTask.new("test:etl" => "test:prepare") do |t|
	t.libs << 'app/etl'
  t.pattern = "test/etl/**/*_test.rb"
end

Rails::TestTask.new("test:etl:benchmark" => "test:prepare") do |t|
	t.libs << 'app/etl'
  t.pattern = "test/etl/**/*_benchmark.rb"
  t.verbose = true
end

Rake::Task["test:run"].enhance ["test:etl"]