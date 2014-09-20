Rails::TestTask.new("test:etl" => "test:prepare") do |t|
	t.libs << 'app/etl'
  t.pattern = "test/etl/**/*_test.rb"
end

Rake::Task["test:run"].enhance ["etl:test:presenters"]