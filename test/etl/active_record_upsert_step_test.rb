require 'test_helper'

class ActiveRecordUpsertStepTest < EtlTestCase
 
  # Stop ActiveRecord from wrapping tests in transactions
  #self.use_transactional_fixtures = false

  def setup
  	# Something about using upsert when a test fails causes subsequent tests that would otherwise work fine to fail 
  	# with 
  	#   PG::InFailedSqlTransaction: ERROR:  current transaction is aborted, commands ignored until end of transaction block
  	#
  	# 
  	ActiveRecord::Base.connection.reconnect!
  end

	test "given an existing record with no changes, does nothing" do
		existing_record = parcels(:initial_parcel)
		created = existing_record.created_at
		updated = existing_record.updated_at

		input = [
			{ 'data' => existing_record.attributes.select { |k,v| k != 'id' && k != 'created_at' && k != 'updated_at' } }
		]

		step = ActiveRecordUpsertStep.new(Parcel, ['folio'])

		run_sink_step(input, step)

		resulting_record = Parcel.find(existing_record.id)

		assert_equal existing_record.attributes, resulting_record.attributes
	end

	test "given an existing record with changes, applies the change" do
		existing_record = parcels(:initial_parcel)
		created = existing_record.created_at
		updated = existing_record.updated_at

		input = [
			{ 'data' => existing_record.attributes.select { |k,v| k != 'id' && k != 'created_at' && k != 'updated_at' } }
		]

		input[0]['data']['owner1'] = "new owner"

		step = ActiveRecordUpsertStep.new(Parcel, ['folio'])

		#Wait at least 1 second, otherwise the resolution of the 'updated_at' value might make it seem like the record wasn't updated
		sleep(5)

		run_sink_step(input, step)

		resulting_record = Parcel.find(existing_record.id)

		assert_equal created, resulting_record.created_at
		assert_operator resulting_record.updated_at, :>, updated
		assert_equal "new owner", resulting.record.owner1
	end
end
