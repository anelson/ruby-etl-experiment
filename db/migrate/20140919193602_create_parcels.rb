class CreateParcels < ActiveRecord::Migration
  def change
    create_table :parcels do |t|
		  t.string :folio, :null => false
			t.string :municipality
			t.string :owner1
			t.string :owner2
			t.string :owner3
			t.string :mailing_address_line1
			t.string :mailing_address_line2
			t.string :mailing_address_line3
			t.string :city
			t.string :state
			t.string :zip
			t.string :country
			t.string :site_address
			t.string :street_number
			t.string :street_prefix
			t.string :street_name
			t.string :street_number_suffix
			t.string :street_suffix
			t.string :street_direction
			t.string :condo_unit
			t.string :site_city
			t.string :site_zip
			t.integer :d_o_r_code
			t.integer :zoning
			t.decimal :sq_ftg
			t.decimal :lot_s_f
			t.decimal :acres
			t.decimal :bedrooms
			t.decimal :baths
			t.integer :half_baths
			t.integer :living_units
			t.integer :stories
			t.integer :number_of_building
			t.integer :year_built
			t.integer :effective_year_built
			t.integer :millage_code

      t.timestamps
    end

    add_index :parcels, :folio, :unique=>true
  end
end
