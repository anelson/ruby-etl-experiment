class RawParcel < ActiveRecord::Base
	@@upsert_instance_cache = {}
	self.primary_key = 'folio'

	def self.load_all_parcels()
	end

	### Creates or updates a Parcel model object and children from raw parcel data
	def upsert_to_parcel()
		# Start with the raw parcel's attributes, adjusting types and removing values that aren't applicable
		# Filter out the current and prior tax roll data, since that will go into a tax roll object,
		# and the folio number, since that's a unique ID and not subject to change
		new_attributes = attributes.reject { |k,v| k.starts_with?("current") || k.starts_with?("prior") || k == "folio" }

		# Convert the integer columns from the string form they take in the raw tables
		new_attributes = intify(new_attributes, Parcel.columns_hash.select { |_, col| col.type == :integer}.keys)

		# And the same for the decimal columns
		new_attributes = decimalify(new_attributes, Parcel.columns_hash.select { |_, col| col.type == :decimal}.keys)

		# NB: This caching approach is NOT threadsafe.  Do not try to upsert from multiple threads at once.
		@@upsert_instance_cache[Parcel] ||= Upsert.new(Parcel.connection, Parcel.table_name)

		@@upsert_instance_cache[Parcel].row({:folio => folio}, new_attributes)
	end

	def intify(hash, keys)
		hash.each { |key, value|
			hash[key] = value.to_i if keys.include?(key) && value != nil 
		}

		hash
	end

	def decimalify(hash, keys)
		hash.each { |key, value|
			hash[key] = value.sub(',', '').to_d if keys.include?(key) && value != nil
		}

		hash
	end
end
